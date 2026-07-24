# == Schema Information
#
# Table name: transactions
#
#  id                     :integer          not null, primary key
#  amount_cents           :integer          not null
#  category               :string
#  currency               :string           default("USD"), not null
#  date                   :date
#  deleted_at             :datetime
#  memo                   :string
#  pending                :boolean          default(FALSE), not null
#  plaid_object           :json
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  account_id             :integer          not null
#  pending_transaction_id :integer
#  plaid_id               :string
#
# Indexes
#
#  index_transactions_on_account_id              (account_id)
#  index_transactions_on_pending_transaction_id  (pending_transaction_id)
#
class Transaction < ApplicationRecord
  acts_as_paranoid

  belongs_to :account
  belongs_to :pending_transaction, optional: true, class_name: "Transaction"

  before_update if: -> { plaid_object_changed? } do
    update!(attributes_from_plaid_object(plaid_object))
  end

  def self.create_from_plaid_object(item, plaid_object)
    account = Account.find_by(plaid_id: plaid_object.account_id, plaid_item_id: item.id)

    if account.nil?
      raise StandardError, "unknown Plaid account with ID #{plaid_object[:account_id]} belonging to #{item.id}"
    end

    account.transactions.create!(attributes_from_plaid_object(plaid_object))
  end

  def self.attributes_from_plaid_object(plaid_object)
    {
      amount_cents: plaid_object.amount * -100,
      currency: plaid_object.iso_currency_code,
      category: plaid_object.personal_finance_category.primary,
      date: plaid_object.date.presence || Date.today,
      memo: plaid_object.original_description,
      pending: plaid_object.pending,
      pending_transaction: plaid_object.pending ? nil : find_by(plaid_id: plaid_object.pending_transaction_id),
      plaid_id: plaid_object.transaction_id,
      plaid_object:
    }
  end

  def amount
    amount_cents / 100.0
  end

  def display_date
    plaid_object["authorized_date"].presence || date
  end
end
