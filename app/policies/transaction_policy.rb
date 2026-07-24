class TransactionPolicy < ApplicationPolicy
  def show?
    record.account.user == user
  end

  alias_method :counterparty_data?, :show?
end
