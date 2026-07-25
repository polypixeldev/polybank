# == Schema Information
#
# Table name: counterparty_transactions
#
#  id              :integer          not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  counterparty_id :integer          not null
#  transaction_id  :integer          not null
#
# Indexes
#
#  index_counterparty_transactions_on_counterparty_id  (counterparty_id)
#  index_counterparty_transactions_on_transaction_id   (transaction_id)
#
class CounterpartyTransaction < ApplicationRecord
  belongs_to :counterparty
  belongs_to :associated_transaction, foreign_key: :transaction_id, class_name: "Transaction"
end
