class PlaidItemsController < ApplicationController
  before_action :set_item

  def sync
    authorize @item

    @item.sync_plaid_transactions

    redirect_back_or_to root_path
  end

  private

  def set_item
    @item = PlaidItem.find(params[:id])
  end
end
