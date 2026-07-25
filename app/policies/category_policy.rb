class CategoryPolicy < ApplicationPolicy
  def show?
    record.users.include?(user)
  end
end
