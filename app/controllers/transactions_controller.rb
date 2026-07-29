class TransactionsController < ApplicationController
  before_action :set_transaction, except: :index

  # before_action :disable_caching, only: [ :edit_category ]

  def index
    skip_authorization

    @query = params[:query]

    @transactions = current_user.transactions.effective.order(pending: :desc, date: :desc)

    @transactions = @transactions.where("memo LIKE ?", "%#{@query}%") if @query.present?

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
