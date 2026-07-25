class CounterpartiesController < ApplicationController
  before_action :set_counterparty, only: [ :show ]
  def index
    skip_authorization

    @query = params[:query]

    @counterparties = current_user.counterparties.order(name: :asc)

    @counterparties = @counterparties.where("counterparties.name LIKE ?", "%#{@query}%") if @query.present?

    @total_amount = Transaction
      .joins(:account, :counterparties)
      .where(accounts: { user_id: current_user.id })
      .where("counterparties.name LIKE ?", "%#{@query}%")
      .sum(:amount_cents) / 100.0
  end

  def show
    authorize @counterparty

    @total_amount = @counterparty.amount_by_user(current_user)
  end

  private

  def set_counterparty
    @counterparty = Counterparty.find(params[:id])
  end
end
