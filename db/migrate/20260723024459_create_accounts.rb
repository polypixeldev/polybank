class CreateAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.string :account_type, null: false
      t.string :mask

      t.string :plaid_id
      t.belongs_to :plaid_item

      t.timestamps
    end
  end
end
