class TransactionsController < ApplicationController
  before_action :set_transaction

  def show
    authorize @transaction
  end

  def counterparty_data
    authorize @transaction

    @counterparty = @transaction.plaid_object["counterparties"].find { |party| party["entity_id"] == params[:entity_id] }
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end
end
