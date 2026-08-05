class AddUniqueIndexOnPlaidIdForTransactions < ActiveRecord::Migration[8.1]
  def change
    add_index :transactions, :plaid_id, unique: true, where: "deleted_at IS NULL"
  end
end
