class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.belongs_to :account, null: false
      t.string :plaid_id

      t.integer :amount_cents, null: false
      t.string :currency, null: false, default: "USD"

      t.datetime :datetime, null: false

      t.string :memo # original desc

      t.boolean :pending, null: false, default: false
      t.belongs_to :pending_transaction

      t.string :category

      t.json :plaid_object

      t.timestamps
    end
  end
end
