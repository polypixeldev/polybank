class PlaidItemPolicy < ApplicationPolicy
  def sync?
    record.user == user
  end

  alias_method :refresh?, :sync?
end
