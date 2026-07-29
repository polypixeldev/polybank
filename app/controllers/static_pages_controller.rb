class StaticPagesController < ApplicationController
  skip_after_action :verify_authorized

  def index
    @recent_transactions = current_user.transactions.effective.order(date: :desc).first(10)
  end
end
