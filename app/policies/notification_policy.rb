class NotificationPolicy < ApplicationPolicy
  def show?
    record.user == user
  end

  alias_method :dismiss?, :show?
end
