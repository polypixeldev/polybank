class AddSoftDeletionToAccount < ActiveRecord::Migration[8.1]
  def change
    add_column :accounts, :deleted_at, :datetime
  end
end
