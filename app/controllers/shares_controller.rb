class SharesController < ApplicationController
  allow_unauthenticated_access only: :show
  before_action :set_share, except: [ :index, :new, :create ]

  def index
    skip_authorization

    @shares = current_user.shares.active
  end

  def new
    skip_authorization
  end

  def create
    share = current_user.shares.build(share_params)

    authorize share

    share.save

    redirect_to share_path(share)
  end

  def show
    authorize @share
  end

  def edit
    authorize @share
  end

  def update
    authorize @share

    @share.update!(share_params)

    redirect_to share_path(@share)
  end

  def destroy
    authorize @share

    @share.destroy!

    redirect_to shares_path
  end

  private

  def share_params
    params.require(:share).permit(:target_gid, :expires_at, :public)
  end

  def set_share
    @share = Share.find(params[:id])
  end
end
