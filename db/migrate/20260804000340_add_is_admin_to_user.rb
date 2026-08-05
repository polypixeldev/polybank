class AddIsAdminToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :is_admin, :boolean, null: false, default: false
  end
end
