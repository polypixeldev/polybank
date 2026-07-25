class CreateCounterpartyTransaction < ActiveRecord::Migration[8.1]
  def change
    create_table :counterparty_transactions do |t|
      t.belongs_to :counterparty, null: false
      t.belongs_to :transaction, null: false

      t.timestamps
    end
  end
end
