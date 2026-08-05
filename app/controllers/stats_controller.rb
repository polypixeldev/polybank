class StatsController < ApplicationController
  def index
    skip_authorization
    apply_filters
  end

  private

  def apply_filters
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

    @end_date = Date.today

    @transactions = current_user.transactions.effective.includes(:reimbursing_transactions)
    @transactions = @transactions.where("date >= ?", @start_date) if @start_date.present?

    @positive_transactions = @transactions.where("transactions.amount_cents > 0")
    @negative_transactions = @transactions.where("transactions.amount_cents > 0")

    @categories = current_user.categories
    @counterparties = current_user.counterparties
    @tags = current_user.tags

    @income_by_category = @positive_transactions.group_by(&:category_id)
                                                .transform_keys { |id| Category.find(id).display_name }
                                                .transform_values { |txns| txns.sum(&:budget_amount_cents)  / 100.0 }

    @expenses_by_category = @negative_transactions.group_by(&:category_id)
      .transform_keys { |id| Category.find(id).display_name }
      .transform_values { |txns| txns.sum(&:budget_amount_cents) / 100.0 }

    @income_by_counterparty = @counterparties.map do |c|
      [ c.name, c.transactions_by_user(current_user).effective.where("transactions.amount_cents > 0 AND transactions.date >= ?", @start_date || Date.new(1000, 1, 1)).to_a.sum(&:budget_amount_cents) / 100.0 ]
    end.reject { |c| c[1] == 0 }.to_h

    @expenses_by_counterparty = @counterparties.map do |c|
      [ c.name, c.transactions_by_user(current_user).effective.where("transactions.amount_cents < 0 AND transactions.date >= ?", @start_date || Date.new(1000, 1, 1)).to_a.sum(&:budget_amount_cents) / 100.0 ]
    end.reject { |c| c[1] == 0 }.to_h

    @income_by_tag = @tags.map do |t|
      [ t.name, t.transactions.effective.where("transactions.amount_cents > 0 AND transactions.date >= ?", @start_date || Date.new(1000, 1, 1)).to_a.sum(&:budget_amount_cents) / 100.0 ]
    end.reject { |t| t[1] == 0 }.to_h

    @expenses_by_tag = @tags.map do |t|
      [ t.name, t.transactions.effective.where("transactions.amount_cents < 0 AND transactions.date >= ?", @start_date || Date.new(1000, 1, 1)).to_a.sum(&:budget_amount_cents) / 100.0 ]
    end.reject { |t| t[1] == 0 }.to_h
  end
end
