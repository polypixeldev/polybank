class TagsController < ApplicationController
  before_action :set_tag, only: [ :show ]

  def index
    skip_authorization

    @query = params[:query]

    @tags = current_user.tags.order(name: :asc)

    @tags = @tags.where("tags.name LIKE ?", "%#{@query}%") if @query.present?

    @total_amount = Transaction.effective.joins(:tags).where(tags: @tags).sum(:amount_cents) / 100.0
  end

  def new
    skip_authorization
  end

  def create
    skip_authorization

    tag = Tag.create!(tag_params.merge(user: current_user))

    redirect_to tag
  end

  def show
    authorize @tag

    @total_amount = @tag.amount
  end

  private

  def tag_params
    params.require(:tag).permit(:name, :color)
  end

  def set_tag
    @tag = Tag.find(params[:id])
  end
end
