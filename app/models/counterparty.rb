# == Schema Information
#
# Table name: counterparties
#
#  id                :integer          not null, primary key
#  counterparty_type :string
#  custom_name       :string
#  logo_url          :string
#  plaid_name        :string
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

  def name
    custom_name.presence || plaid_name
  end

  def transactions_by_user(user)
    transactions.effective.joins(:account).where("accounts.user_id = ?", user.id)
  end

  def amount_by_user(user)
    transactions_by_user(user).sum(:amount_cents) / 100.0
  end
end
