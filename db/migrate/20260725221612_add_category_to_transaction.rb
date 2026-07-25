class AddCategoryToTransaction < ActiveRecord::Migration[8.1]
  def change
    add_reference :transactions, :category
  end
end
