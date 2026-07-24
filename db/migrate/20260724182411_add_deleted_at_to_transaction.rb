class AddDeletedAtToTransaction < ActiveRecord::Migration[8.1]
  def change
    add_column :transactions, :deleted_at, :datetime
  end
end
