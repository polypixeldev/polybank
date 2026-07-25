class CategoriesController < ApplicationController
  before_action :set_category, only: [ :show ]

  def index
    skip_authorization

    @query = params[:query]

    @categories = current_user.categories.order(custom_name: :asc, plaid_name: :asc)

    @categories = @categories.where("categories.plaid_name LIKE ? OR categories.custom_name LIKE ?", "%#{@query}%", "%#{@query}%") if @query.present?

    @total_amount = Transaction
      .joins(:account, :category)
      .where(accounts: { user_id: current_user.id })
      .where("categories.plaid_name LIKE ? OR categories.custom_name LIKE ?", "%#{@query}%", "%#{@query}%")
      .sum(:amount_cents) / 100.0
  end

  def show
    authorize @category

    @total_amount = @category.transactions_by_user(current_user).sum(:amount_cents) / 100.0
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end
end
