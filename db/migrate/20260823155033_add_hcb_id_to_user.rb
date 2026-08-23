class AddHcbIdToUser < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :hcb_id, :string
  end
end
