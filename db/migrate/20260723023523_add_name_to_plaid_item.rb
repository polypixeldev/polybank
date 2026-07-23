class AddNameToPlaidItem < ActiveRecord::Migration[8.1]
  def change
    add_column :plaid_items, :name, :string
  end
end
