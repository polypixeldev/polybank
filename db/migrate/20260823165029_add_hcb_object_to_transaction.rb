class AddHcbObjectToTransaction < ActiveRecord::Migration[8.1]
  def change
    add_column :transactions, :hcb_object, :json
  end
end
