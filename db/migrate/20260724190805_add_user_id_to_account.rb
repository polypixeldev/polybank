class AddUserIdToAccount < ActiveRecord::Migration[8.1]
  def change
    add_reference :accounts, :user
  end
end
