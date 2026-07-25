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
#  category_id            :integer
#  pending_transaction_id :integer
#  plaid_id               :string
#
# Indexes
#
#  index_transactions_on_account_id              (account_id)
#  index_transactions_on_category_id             (category_id)
#  index_transactions_on_pending_transaction_id  (pending_transaction_id)
#
class Transaction < ApplicationRecord
  acts_as_paranoid

  belongs_to :account
  belongs_to :pending_transaction, optional: true, class_name: "Transaction"
  belongs_to :category, optional: true

  has_one :user, through: :account

  has_many :counterparty_transactions
  has_many :counterparties, through: :counterparty_transactions

  before_save if: -> { plaid_object_changed? } do
    update!(attributes_from_plaid_object(plaid_object))
  end

  after_save :update_counterparties_from_plaid, if: -> { plaid_object_previously_changed? }
  after_save :update_category_from_plaid, if: -> { plaid_object_previously_changed? }

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

  private

  def update_counterparties_from_plaid
    plaid_counterparties = plaid_object["counterparties"]

    ActiveRecord::Base.transaction do
      counterparty_transactions.destroy_all

      plaid_counterparties.each do |plaid_counterparty|
        counterparty = nil

        if plaid_counterparty["entity_id"].present?
          Counterparty.find_by(plaid_id: plaid_counterparty["entity_id"])
        end

        if counterparty.nil?
          counterparty = Counterparty.find_by(name: plaid_counterparty["name"])
        end

        if counterparty.nil?
          counterparty = Counterparty.create!(
            plaid_id: plaid_counterparty["entity_id"],
            name: plaid_counterparty["name"]
          )
        end

        counterparty.update!({
          plaid_id: plaid_counterparty["entity_id"],
          name: plaid_counterparty["name"],
          counterparty_type: plaid_counterparty["type"],
          website: plaid_counterparty["website"],
          logo_url: plaid_counterparty["logo_url"]
        }.compact_blank)


        counterparties << counterparty
      end
    end
  end

  def update_category_from_plaid
    plaid_category = plaid_object["personal_finance_category"]["primary"]

    category = Category.find_or_create_by!(plaid_name: plaid_category)

    update!(category:)
  end
end
