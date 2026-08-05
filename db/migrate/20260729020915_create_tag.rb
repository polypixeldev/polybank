class CreateTag < ActiveRecord::Migration[8.1]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.string :color, null: false

      t.belongs_to :user, null: false

      t.timestamps
    end
  end
end
