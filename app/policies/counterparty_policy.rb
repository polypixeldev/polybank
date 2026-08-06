class CounterpartyPolicy < ApplicationPolicy
  def show?
    record.users.include?(user)
  end

  def update?
    record.users.include?(user)
  end

  alias_method :edit_name?, :update?
  alias_method :budget?, :show?
end
