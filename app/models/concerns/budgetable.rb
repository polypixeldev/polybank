module Budgetable
  extend ActiveSupport::Concern

  def self.budgetable_models
    ApplicationRecord.descendants.select { |model| model.included_modules.include?(Budgetable) }
  end

  def self.available_budgetables(user)
    budgetables = []

    budgetable_models.each do |model|
      budgetables += model.all.select { |record| Pundit.policy(user, record).budget? }
    end

    budgetables
  end

  def total_budget_amount_cents(user, period, day = Date.today)
    qualifying_txns = budgetable_transactions.effective.within_period(period, day)

    qualifying_txns.includes(:reimbursing_transactions).to_a.sum(&:budget_amount_cents)
  end

  def budgetable_transactions(user)
    raise NotImplementedError, "#{self.class.name} has not implemented budgetable_transactions"
  end
end
