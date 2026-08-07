class CreateView < ActiveRecord::Migration[8.1]
  def change
    create_table :views do |t|
      t.string :name
      t.belongs_to :user, null: false

      t.string :memo
      t.date :start_date
      t.date :end_date
      t.belongs_to :account
      t.belongs_to :category
      t.belongs_to :counterparty
      t.belongs_to :tag
      t.integer :min_amount
      t.integer :max_amount
      t.string :direction

      t.timestamps
    end
  end
end
