# == Schema Information
#
# Table name: budgets
#
#  id                 :integer          not null, primary key
#  active             :boolean          default(TRUE), not null
#  limit_amount_cents :integer          not null
#  name               :string           not null
#  period             :string           not null
#  target_type        :string           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  target_id          :integer          not null
#  user_id            :integer          not null
#
# Indexes
#
#  index_budgets_on_target   (target_type,target_id)
#  index_budgets_on_user_id  (user_id)
#
class Budget < ApplicationRecord
  belongs_to :user
  belongs_to :target, polymorphic: true

  enum :period, { week: "week", month: "month", year: "year" }, prefix: :week

  def self.period_start_date(period, day = Date.today)
    case period
    when "week"
      day.beginning_of_week
    when "month"
      day.beginning_of_month
    when "year"
      day.beginning_of_year
    else
      Date.new(1, 1, 1000)
    end
  end

  def self.period_end_date(period, day = Date.today)
    case period
    when "week"
      day.end_of_week
    when "month"
      day.end_of_month
    when "year"
      day.end_of_year
    else
      Date.new(1, 1, 10000)
    end
  end

  def period_start_date(day = Date.today)
    Budget.period_start_date(period, day)
  end

  def period_end_date(day = Date.today)
    Budget.period_end_date(period, day)
  end

  def status_text
    return "Inactive" unless active
    passing? ? "Passing" : "Failing"
  end

  def passing?
    target.total_budget_amount_cents(user, period, Date.today) <= limit_amount_cents
  end

  def failing?
    !passing?
  end

  def limit_amount
    limit_amount_cents / 100.0
  end

  def remaining_amount_in_period(day = Date.today)
    remaining_amount_cents_in_period(day) / 100.0
  end

  def remaining_amount_cents_in_period(day = Date.today)
    limit_amount_cents - target.total_budget_amount_cents(user, period, day)
  end

  def target_gid
    target&.to_global_id
  end

  def target_gid=(gid)
    self.target = GlobalID::Locator.locate gid
  end
end
