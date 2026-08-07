class BudgetsController < ApplicationController
  before_action :set_budget, except: [ :index, :new, :create ]

  def index
    skip_authorization

    @budgets = current_user.budgets
  end

  def new
    skip_authorization
  end

  def create
    budget = current_user.budgets.build(budget_params)

    authorize budget

    budget.save

    redirect_to budget_path(budget)
  end

  def show
    authorize @budget

    @recent_periods = []

    loop do
      base_day = (@recent_periods.last&.first || @budget.period_start_date) - 1.day

      break if base_day < @budget.created_at

      @recent_periods.push([ Budget.period_start_date(@budget.period, base_day), Budget.period_end_date(@budget.period, base_day) ])
    end
  end

  def edit
    authorize @budget
  end

  def update
    authorize @budget

    @budget.update!(budget_params)

    redirect_to budget_path(@budget)
  end

  def destroy
    authorize @budget

    @budget.destroy!

    redirect_to budgets_path
  end

  private

  def budget_params
    params.require(:budget).permit(:name, :active, :period, :target_gid).merge(limit_amount_cents: params[:budget][:limit_amount].to_f * 100)
  end

  def set_budget
    @budget = Budget.find(params[:id])
  end
end
