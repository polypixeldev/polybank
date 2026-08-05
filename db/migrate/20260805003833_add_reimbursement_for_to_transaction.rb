class AddReimbursementForToTransaction < ActiveRecord::Migration[8.1]
  def change
    add_reference :transactions, :reimbursement_for
  end
end
