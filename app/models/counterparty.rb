# == Schema Information
#
# Table name: counterparties
#
#  id                :integer          not null, primary key
#  counterparty_type :string
#  logo_url          :string
#  name              :string
#  website           :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  plaid_id          :string
#
# Indexes
#
#  index_counterparties_on_plaid_id  (plaid_id) UNIQUE
#
class Counterparty < ApplicationRecord
  has_many :counterparty_transactions
  has_many :transactions, through: :counterparty_transactions, source: :associated_transaction

  has_many :users, through: :transactions

  def transactions_by_user(user)
    transactions.joins(:account).where("accounts.user_id = ?", user.id)
  end

  def amount_by_user(user)
    transactions_by_user(user).sum(:amount_cents) / 100.0
  end
end
