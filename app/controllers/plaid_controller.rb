class PlaidController < ApplicationController
  allow_unauthenticated_access only: :webhook
  before_action :verify_webhook, only: [ :webhook ]
  skip_forgery_protection only: :webhook
  skip_after_action :verify_authorized

  def webhook
    if params[:webhook_type] == "TRANSACTIONS" && params[:webhook_code] == "SYNC_UPDATES_AVAILABLE"
      if params[:historical_update_complete]
        item = PlaidItem.find_by(item_id: params[:item_id])
        item&.sync_plaid_transactions
      end
    end

    head :ok
  end

  def linked
    link_token = params[:link_token]

    session = PlaidService.get_link_token_session_info(link_token)

    session.results.item_add_results.each do |item|
      public_token = item.public_token
      item_data = PlaidService.exchange_public_token(public_token)

      current_user.plaid_items.create!(item_id: item_data.item_id, access_token: item_data.access_token)
    end

    redirect_to root_path
  end

  def generate_link_token
    link_token = PlaidService.generate_link_token(current_user.plaid_id)

    render json: { link_token: }
  end

  private

  def verify_webhook
    raw_jwt = request.headers["Plaid-Verification"]

    if raw_jwt.blank?
      head :unauthorized
      return
    end

    encoded_token = JWT::EncodedToken.new(raw_jwt)

    unless encoded_token.header["alg"] == "ES256"
      head :unauthorized
      return
    end

    key_id = encoded_token.header["kid"]

    webhook_key = PlaidService.get_webhook_verification_key(key_id)
    jwk = JWT::JWK.new(webhook_key)

    encoded_token.verify!(signature: { algorithm: "ES256", key: jwk })

    claimed_hash = encoded_token.payload["request_body_sha256"]
    body_hash = Digest::SHA256.hexdigest(request.raw_post)

    unless claimed_hash.is_a?(String) && ActiveSupport::SecurityUtils.secure_compare(claimed_hash, body_hash)
      head :unauthorized
      return
    end

    iat = encoded_token.payload["iat"]

    unless iat.is_a?(Integer) && Time.now.to_i - iat <= 60 * 5
      head :unauthorized
    end
  rescue JWT::DecodeError
    head :unauthorized
  end
end
