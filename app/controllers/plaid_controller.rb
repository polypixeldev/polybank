class PlaidController < ApplicationController
  def webhook
  end

  def link
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
end
