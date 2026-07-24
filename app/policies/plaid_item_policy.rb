class PlaidItemPolicy < ApplicationPolicy
  def sync?
    record.user == user
  end
end
