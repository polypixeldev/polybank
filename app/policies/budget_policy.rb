class BudgetPolicy < ApplicationPolicy
  def show?
    record.user == user
  end

  def update?
    record.user == user && budgetable_target?
  end

  alias_method :index?, :show?
  alias_method :edit?, :show?
  alias_method :destroy?, :show?
  alias_method :create?, :update?

  private

  def budgetable_target?
    Budgetable::BUDGETABLE_MODELS.any? { |model| record.target.is_a?(model) } &&
      Pundit.policy(user, record.target).budget?
  end
end
