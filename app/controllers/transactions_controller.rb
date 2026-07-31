class TransactionsController < ApplicationController
  before_action :set_transaction, except: [ :index, :list, :export ]

  def index
    skip_authorization
  end

  def list
    skip_authorization

    @show_filters = ActiveModel::Type::Boolean.new.cast(params[:show_filters])

    apply_filters
  end

  def export
    skip_authorization

    apply_filters

    respond_to do |format|
      format.csv do
        render csv: @transactions
      end

      format.pdf do
        html = render_to_string(template: "transactions/export", layout: "pdf")
        pdf = Grover.new(html).to_pdf

        send_data pdf, filename: "transaction_export_#{Date.today.to_s.gsub("-", "_")}", type: "application/pdf"
      end
    end
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

  def toggle_tag
    authorize @transaction

    tag = Tag.find(params[:tag_id])

    if @transaction.tags.include? tag
      TagTransaction.find_by(tag:, associated_transaction: @transaction).destroy
    else
      @transaction.tags << tag
    end

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

  def apply_filters
    @transactions = current_user.transactions.effective.order(pending: :desc, date: :desc)
    @query = params[:query]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @account = current_user.accounts.find_by(id: params[:account_id])
    @category = current_user.categories.find_by(id: params[:category_id])
    @counterparty = current_user.counterparties.find_by(id: params[:counterparty_id])
    @tag = current_user.tags.find_by(id: params[:tag_id])
    @min_amount = params[:min_amount]
    @max_amount = params[:max_amount]
    @direction = params[:direction]

    @transactions = @transactions.where("transactions.memo LIKE ?", "%#{@query}%") if @query.present?
    @transactions = @transactions.where("transactions.date >= ?", @start_date) if @start_date.present?
    @transactions = @transactions.where("transactions.date < ?", @end_date) if @end_date.present?
    @transactions = @transactions.where(account: @account) if @account.present?
    @transactions = @transactions.where(category: @category) if @category.present?
    @transactions = @transactions.joins(:counterparties).where(counterparties: @counterparty) if @counterparty.present?
    @transactions = @transactions.joins(:tags).where(tags: @tag) if @tag.present?
    @transactions = @transactions.where("abs(transactions.amount_cents) >= ?", @min_amount.to_f * 100) if @min_amount.present?
    @transactions = @transactions.where("abs(transactions.amount_cents) < ?", @max_amount.to_f * 100) if @max_amount.present?

    if @direction == "incoming"
      @transactions = @transactions.where("transactions.amount_cents > 0")
    elsif @direction == "outgoing"
      @transactions = @transactions.where("transactions.amount_cents < 0")
    end

    @total_amount = @transactions.sum(:amount_cents) / 100.0
  end
end
