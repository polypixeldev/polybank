class TransactionPolicy < ApplicationPolicy
  def show?
    record.account.user == user
  end

  def edit_memo?
    record.account.user == user
  end

  alias_method :edit_category?, :edit_memo?

  alias_method :update?, :edit_memo?
end
