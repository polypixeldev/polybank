class CreateTagTransaction < ActiveRecord::Migration[8.1]
  def change
    create_table :tag_transactions do |t|
      t.belongs_to :tag, null: false
      t.belongs_to :transaction, null: false

      t.timestamps
    end
  end
end
