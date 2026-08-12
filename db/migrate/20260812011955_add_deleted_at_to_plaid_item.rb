class AddDeletedAtToPlaidItem < ActiveRecord::Migration[8.1]
  def change
    add_column :plaid_items, :deleted_at, :datetime
  end
end
