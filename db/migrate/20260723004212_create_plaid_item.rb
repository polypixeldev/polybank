class CreatePlaidItem < ActiveRecord::Migration[8.1]
  def change
    create_table :plaid_items do |t|
      t.string :access_token, null: false
      t.string :item_id, null: false

      t.belongs_to :user, null: false

      t.timestamps
    end
  end
end
