class TransactionPolicy < ApplicationPolicy
  def show?
    record.account.user == user
  end
end
