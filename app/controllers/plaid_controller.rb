class PlaidController < ApplicationController
  def webhook
  end

  def link
  end

  def linked
    public_token = params[:public_token]

    access_token = PlaidService.exchange_public_token(public_token)

    current_user.update!(plaid_access_token: access_token)

    redirect_to root_path
  end

  def generate_link_token
    link_token = PlaidService.generate_link_token(current_user.public_id)

    render json: { link_token: }
  end
end
