class StatsController < ApplicationController
  def index
    skip_authorization

    @time_frame = params[:time_frame]

    @start_date = case @time_frame
    when "week"
      Date.today.beginning_of_week
    when "month"
      Date.today.beginning_of_month
    when "year"
      Date.today.beginning_of_year
    else
      nil
    end

    @transactions = current_user.transactions
    @transactions = @transactions.where("date >= ?", @start_date) if @start_date.present?

    @categories = current_user.categories
    @counterparties = current_user.counterparties
    @tags = current_user.tags
  end
end
