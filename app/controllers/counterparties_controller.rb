class CounterpartiesController < ApplicationController
  before_action :set_counterparty, only: [ :show ]
  def index
    skip_authorization

    @query = params[:query]

    if @query.present?
      @counterparties = current_user.counterparties
        .where("counterparties.name LIKE ?", "%#{@query}%")

      @total_amount = Transaction
        .joins(:account, :counterparties)
        .where(accounts: { user_id: current_user.id })
        .where("counterparties.name LIKE ?", "%#{@query}%")
        .sum(:amount_cents) / 100.0
    end
  end

  def show
    authorize @counterparty

    @total_amount = @counterparty.transactions_by_user(current_user).sum(:amount_cents) / 100.0
  end

  private

  def set_counterparty
    @counterparty = Counterparty.find(params[:id])
  end
end
