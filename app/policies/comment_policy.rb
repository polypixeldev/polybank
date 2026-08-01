class CommentPolicy < ApplicationPolicy
  def update?
    record.author == user
  end

  alias_method :edit?, :update?
  alias_method :destroy?, :update?
end
