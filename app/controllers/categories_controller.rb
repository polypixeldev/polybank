class CategoriesController < ApplicationController
  before_action :set_category, only: [ :show ]

  def index
    skip_authorization

    @query = params[:query]

    @categories = current_user.categories.order(name: :asc)

    @categories = @categories.where("categories.name LIKE ?", "%#{@query}%") if @query.present?

    @total_amount = Transaction
      .effective
      .joins(:account, :category)
      .where(accounts: { user_id: current_user.id })
      .where("categories.name LIKE ?", "%#{@query}%")
      .sum(:amount_cents) / 100.0
  end

  def show
    authorize @category

    @total_amount = @category.amount_by_user(current_user)
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end
end
