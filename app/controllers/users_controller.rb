class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  def new
    @user = User.new
  end

  def create
    user = User.create!(user_params)

    redirect_to home_path(user)
  end

  private

  def user_params
    params.require(:user).permit(:name, :email_address, :password)
  end
end
