class TagPolicy < ApplicationPolicy
  def show?
    record.user == user
  end

  alias_method :edit?, :show?
  alias_method :update?, :show?
  alias_method :destroy?, :show?
  alias_method :budget?, :show?
  alias_method :toggle_tag?, :show?
end
