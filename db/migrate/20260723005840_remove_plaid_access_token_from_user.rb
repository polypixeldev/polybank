class RemovePlaidAccessTokenFromUser < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :plaid_access_token, :string
  end
end
