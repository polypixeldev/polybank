class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  before_action :set_user, only: [ :update ]
  skip_after_action :verify_authorized, except: :update

  def new
    @user = User.new
  end

  def create
    user = User.create!(initial_user_params)

    redirect_to home_path(user)
  end

  def settings
    @user = current_user
  end

  def update
    authorize @user

    @user.update!(update_user_params)

    redirect_back_or_to settings_path
  end

  private

  def initial_user_params
    params.require(:user).permit(:name, :email_address, :password)
  end

  def update_user_params
    params.require(:user).permit(:hcb_id)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
