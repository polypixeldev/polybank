module Budgetable
  extend ActiveSupport::Concern

  BUDGETABLE_MODELS = [ Account, Category, Counterparty, Tag ]

  def self.available_budgetables(user)
    available_budgetables_list = []

    BUDGETABLE_MODELS.each do |model|
      available_budgetables_list.push [ model.name.humanize, model.all.select { |record| Pundit.policy(user, record).budget? }.map { |r| [ r.display_name, r.to_global_id ] } ]
    end

    available_budgetables_list
  end

  def total_budget_amount_cents(user, period, day = Date.today)
    qualifying_txns = budgetable_transactions(user).effective.within_period(period, day)

    qualifying_txns.includes(:reimbursing_transactions).to_a.sum(&:budget_amount_cents)
  end

  def budgetable_transactions(user)
    raise NotImplementedError, "#{self.class.name} has not implemented budgetable_transactions"
  end
end
