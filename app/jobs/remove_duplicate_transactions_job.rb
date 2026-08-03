class RemoveDuplicateTransactionsJob < ApplicationJob
  def perform
    dup_groups = Transaction.effective.group_by { |t| t.plaid_id }
    dup_groups.each do |id, txns|
      txns.first(txns.size - 1).each(&:destroy)
    end
  end
end
