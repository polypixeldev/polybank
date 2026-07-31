class TagPolicy < ApplicationPolicy
  def show?
    record.user == user
  end

  alias_method :edit?, :show?
  alias_method :update?, :show?
  alias_method :destroy?, :show?
end
