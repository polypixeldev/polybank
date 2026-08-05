class PlaidItemsController < ApplicationController
  before_action :set_item, except: :refresh_and_sync_all

  def sync
    authorize @item

    @item.sync_plaid_transactions

    redirect_back_or_to root_path
  end

  def refresh
    authorize @item

    @item.refresh_plaid_transactions

    redirect_back_or_to root_path
  end

  def refresh_and_sync_all
    skip_authorization

    current_user.plaid_items.each do |item|
      begin
        item.refresh_plaid_transactions
      rescue
        nil
      end

      item.sync_plaid_transactions
    end

    redirect_back_or_to root_path
  end

  private

  def set_item
    @item = PlaidItem.find(params[:id])
  end
end
