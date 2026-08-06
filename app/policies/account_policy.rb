class AccountPolicy < ApplicationPolicy
  def show?
    record.user == user
  end

  alias_method :budget?, :show?
end
