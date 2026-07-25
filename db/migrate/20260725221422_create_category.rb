class CreateCategory < ActiveRecord::Migration[8.1]
  def change
    create_table :categories do |t|
      t.string :plaid_name
      t.string :custom_name

      t.timestamps
    end
  end
end
