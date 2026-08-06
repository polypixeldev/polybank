class CreateBudget < ActiveRecord::Migration[8.1]
  def change
    create_table :budgets do |t|
      t.string :name, null: false
      t.string :period, null: false
      t.integer :limit_amount_cents, null: false
      t.boolean :active, null: false, default: true

      t.belongs_to :target, polymorphic: true, null: false
      t.belongs_to :user, null: false

      t.timestamps
    end
  end
end
