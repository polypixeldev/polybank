class AddFieldsToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :name, :string, null: false
    add_column :users, :plaid_access_token, :string
  end
end
