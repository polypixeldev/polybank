class TransactionsController < ApplicationController
  before_action :set_transaction, only: [ :show, :counterparty_data ]

  def show
    authorize @transaction
  end

  def counterparty_data
    authorize @transaction

    @counterparty = @transaction.plaid_object["counterparties"].find { |party| party["entity_id"] == params[:entity_id] }
  end

  def search
    skip_authorization

    @query = params[:query]

    if @query.present?
      @transactions = current_user.transactions

      @transactions = @transactions.where("memo LIKE ?", "%#{@query}%")

      @total_amount = @transactions.sum(:amount_cents) / 100.0
    end
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end
end
