class TagPolicy < ApplicationPolicy
  def show?
    record.user == user
  end
end
