class CounterpartiesController < ApplicationController
  before_action :set_counterparty, except: :index

  def index
    skip_authorization

    @query = params[:query]

    @counterparties = current_user.counterparties.order(custom_name: :asc, plaid_name: :asc)

    @counterparties = @counterparties.where("counterparties.custom_name LIKE ? OR counterparties.plaid_name LIKE ?", "%#{@query}%", "%#{@query}%") if @query.present?

    @total_amount = Transaction
      .joins(:account, :counterparties)
      .where(accounts: { user_id: current_user.id })
      .where("counterparties.custom_name LIKE ? OR counterparties.plaid_name LIKE ?", "%#{@query}%", "%#{@query}%")
      .sum(:amount_cents) / 100.0
  end

  def show
    authorize @counterparty

    @total_amount = @counterparty.amount_by_user(current_user)
  end

  def update
    authorize @counterparty

    @counterparty.update!(counterparty_params)

    redirect_back_or_to @counterparty
  end

  def edit_name
    authorize @counterparty
  end

  private

  def set_counterparty
    @counterparty = Counterparty.find(params[:id])
  end

  def counterparty_params
    params.require(:counterparty).permit(:custom_name)
  end
end
