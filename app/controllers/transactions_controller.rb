class TransactionsController < ApplicationController
  before_action :set_transaction, only: [ :show, :counterparty_data ]

  def show
    authorize @transaction
  end

  def counterparty_data
    authorize @transaction

    @counterparty = @transaction.plaid_object["counterparties"].find { |party| party["entity_id"] == params[:entity_id] }
  end

  def index
    skip_authorization

    @query = params[:query]

    @transactions = current_user.transactions.order(pending: :desc, date: :desc)

    @transactions = @transactions.where("memo LIKE ?", "%#{@query}%") if @query.present?

    @total_amount = @transactions.sum(:amount_cents) / 100.0
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end
end
