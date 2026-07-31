class DropCategoryFromTransaction < ActiveRecord::Migration[8.1]
  def change
    remove_column :transactions, :category, :string
  end
end
