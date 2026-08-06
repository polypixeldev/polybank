class BudgetPolicy < ApplicationPolicy
  def show?
    record.user == user
  end

  def update?
    record.user == user
  end

  alias_method :index?, :show?
  alias_method :edit?, :update?
  alias_method :destroy?, :update?
  alias_method :create?, :update?
end
