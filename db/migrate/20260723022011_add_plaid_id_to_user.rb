class AddPlaidIdToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :plaid_id, :string
  end
end
