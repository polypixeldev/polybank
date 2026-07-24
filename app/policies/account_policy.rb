class AccountPolicy < ApplicationPolicy
  def show?
    record.user == user
  end
end
