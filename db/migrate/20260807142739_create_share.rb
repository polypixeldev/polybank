class CreateShare < ActiveRecord::Migration[8.1]
  def change
    create_table :shares do |t|
      t.belongs_to :user, null: false
      t.belongs_to :target, null: false, polymorphic: true

      t.boolean :public, null: false, default: false
      t.datetime :expires_at

      t.timestamps
    end
  end
end
