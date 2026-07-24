class AccountsController < ApplicationController
  before_action :set_account

  def show
    authorize @account
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end
end
