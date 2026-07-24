class AddTransactionCursorToItem < ActiveRecord::Migration[8.1]
  def change
    add_column :plaid_items, :transaction_cursor, :string
  end
end
