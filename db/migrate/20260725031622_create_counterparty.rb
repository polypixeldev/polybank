class CreateCounterparty < ActiveRecord::Migration[8.1]
  def change
    create_table :counterparties do |t|
      t.string :name
      t.string :plaid_id
      t.string :counterparty_type
      t.string :website
      t.string :logo_url

      t.timestamps
    end

    add_index :counterparties, :plaid_id, unique: true
  end
end
