module TransactionList
  extend ActiveSupport::Concern

  def apply_transaction_filters(user)
    @transactions = user.transactions.effective.order(pending: :desc, date: :desc)
    @query = params[:query]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @account = user.accounts.find_by(id: params[:account_id])
    @category = user.categories.find_by(id: params[:category_id])
    @counterparty = user.counterparties.find_by(id: params[:counterparty_id])
    @tag = user.tags.find_by(id: params[:tag_id])
    @min_amount = params[:min_amount]
    @max_amount = params[:max_amount]
    @direction = params[:direction]

    @transactions = Transaction.apply_filters(@transactions, {
      memo: @query,
      start_date: @start_date,
      end_date: @end_date,
      account: @account,
      category: @category,
      counterparty: @counterparty,
      tag: @tag,
      min_amount: @min_amount,
      max_amount: @max_amount,
      direction: @direction
    })

    @total_amount = @transactions.sum(:amount_cents) / 100.0

    @transactions
  end
end
