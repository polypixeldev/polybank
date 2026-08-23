class HcbOrganizationPolicy < ApplicationPolicy
  def sync?
    record.user == user
  end
end
