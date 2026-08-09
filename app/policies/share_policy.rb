class SharePolicy < ApplicationPolicy
  def show?
    record.user == user || (record.active? && (record.public? ||  record.shared_users.include?(user)))
  end

  def update?
    record.user == user
  end

  alias_method :edit?, :update?
  alias_method :destroy?, :update?
  alias_method :create?, :update?
end
