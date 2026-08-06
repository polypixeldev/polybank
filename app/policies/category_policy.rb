class CategoryPolicy < ApplicationPolicy
  def show?
    record.users.include?(user)
  end

  alias_method :budget?, :show?
end
