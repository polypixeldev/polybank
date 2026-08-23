class AddHcbIdToTransaction < ActiveRecord::Migration[8.1]
  def change
    add_column :transactions, :hcb_id, :string
  end
end
