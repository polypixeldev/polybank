class ViewsController < ApplicationController
  include TransactionList

  allow_unauthenticated_access only: :show
  before_action :set_view, except: [ :index, :create ]

  def index
    skip_authorization

    @views = current_user.views
  end

  def create
    skip_authorization

    view = current_user.views.create!(searchbar_view_params)

    redirect_to view_path(view)
  end

  def show
    authorize_with_share @view, params[:share_sid]

    apply_transaction_filters(@view.user)
  end

  def edit
    authorize @view
  end

  def update
    authorize @view

    @view.update!(view_params)

    redirect_to view_path(@view)
  end

  def destroy
    authorize @view

    @view.destroy!

    redirect_to views_path
  end

  private

  def set_view
    @view = View.find(params[:id])
  end

  def searchbar_view_params
    params.permit(:start_date,
                  :end_date,
                  :account_id,
                  :category_id,
                  :counterparty_id,
                  :tag_id,
                  :min_amount,
                  :max_amount,
                  :direction).merge(memo: params[:query], name: "New View")
  end

  def view_params
    params.require(:view).permit(:name,
                                 :memo,
                                 :start_date,
                                 :end_date,
                                 :account_id,
                                 :category_id,
                                 :counterparty_id,
                                 :tag_id,
                                 :min_amount,
                                 :max_amount,
                                 :direction)
  end
end
