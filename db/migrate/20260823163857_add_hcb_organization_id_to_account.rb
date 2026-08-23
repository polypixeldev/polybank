class AddHcbOrganizationIdToAccount < ActiveRecord::Migration[8.1]
  def change
    add_reference :accounts, :hcb_organization
  end
end
