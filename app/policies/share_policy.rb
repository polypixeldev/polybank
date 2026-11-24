class SharePolicy < ApplicationPolicy
  def show?
    record.user == user || (record.active? && (record.public? ||  record.shared_users.include?(user)))
  end

  def edit?
    record.user == user
  end

  def update?
    edit? && shareable_target?
  end

  alias_method :destroy?, :edit?
  alias_method :create?, :update?

  private

  def shareable_target?
    Shareable::SHAREABLE_MODELS.any? { |model| record.target.is_a?(model) } &&
      Pundit.policy(user, record.target).share?
  end
end
