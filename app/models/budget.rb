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

  def passing?
    target.total_budget_amount_cents <= limit_amount_cents
  end

  def failing?
    !passing?
  end

  def target_gid
    target&.to_global_id
  end

  def target_gid=(gid)
    self.target = GlobalID::Locator.locate gid
  end
end
