class UserPolicy < ApplicationPolicy
  def update?
    record == user || user.admin?
  end
end
