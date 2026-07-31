class TransactionsController < ApplicationController
  before_action :set_transaction, except: :index

  def index
    skip_authorization

    @query = params[:query]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @category = current_user.categories.find_by(id: params[:category_id])
    @counterparty = current_user.counterparties.find_by(id: params[:counterparty_id])
    @min_amount = params[:min_amount]
    @max_amount = params[:max_amount]
    @direction = params[:direction]

    @transactions = current_user.transactions.effective.order(pending: :desc, date: :desc)

    @transactions = @transactions.where("transactions.memo LIKE ?", "%#{@query}%") if @query.present?
    @transactions = @transactions.where("transactions.date >= ?", @start_date) if @start_date.present?
    @transactions = @transactions.where("transactions.date < ?", @end_date) if @end_date.present?
    @transactions = @transactions.where(category: @category) if @category.present?
    @transactions = @transactions.joins(:counterparties).where(counterparties: @counterparty) if @counterparty.present?
    @transactions = @transactions.where("abs(transactions.amount_cents) >= ?", @min_amount.to_f * 100) if @min_amount.present?
    @transactions = @transactions.where("abs(transactions.amount_cents) < ?", @max_amount.to_f * 100) if @max_amount.present?

    if @direction == "incoming"
      @transactions = @transactions.where("transactions.amount_cents > 0")
    elsif @direction == "outgoing"
      @transactions = @transactions.where("transactions.amount_cents < 0")
    end

    @total_amount = @transactions.sum(:amount_cents) / 100.0
  end

  def show
    authorize @transaction
  end

  def edit_memo
    authorize @transaction
  end

  def edit_category
    authorize @transaction
  end

  def add_tag_modal
    authorize @transaction
  end

  def add_tag
    authorize @transaction

    tag = Tag.find(params[:tag_id])

    @transaction.tags << tag

    redirect_back_or_to @transaction
  end

  def update
    authorize @transaction

    @transaction.update!(transaction_params)

    redirect_back_or_to @transaction
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:memo, :category_id)
  end
end
