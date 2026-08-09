class CreateSharePermission < ActiveRecord::Migration[8.1]
  def change
    create_table :share_permissions do |t|
      t.belongs_to :share, null: false
      t.belongs_to :user, null: false

      t.timestamps
    end
  end
end
