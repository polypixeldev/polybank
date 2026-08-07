# == Schema Information
#
# Table name: plaid_items
#
#  id                 :integer          not null, primary key
#  access_token       :string           not null
#  name               :string
#  transaction_cursor :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  item_id            :string           not null
#  user_id            :integer          not null
#
# Indexes
#
#  index_plaid_items_on_user_id  (user_id)
#
class PlaidItem < ApplicationRecord
  include ActionView::Helpers::TextHelper

  belongs_to :user
  has_many :accounts
  has_many :transactions, through: :accounts

  encrypts :access_token

  after_create :fetch_plaid_metadata
  after_create :sync_plaid_transactions

  def sync_plaid_transactions
    all_data = fetch_new_sync_data(transaction_cursor)

    added = 0
    modified = 0
    removed = 0
    settled = 0

    ActiveRecord::Base.transaction do
      added_ids = []

      all_data[:added].each do |txn|
        Transaction.create_from_plaid_object(self, txn)

        added += 1
        added_ids.push txn.transaction_id
      end

      all_data[:modified].each do |txn|
        Transaction.find_by(plaid_id: txn.transaction_id, plaid_object: txn)

        modified += 1
      end

      all_data[:removed].each do |txn|
        db_txn = Transaction.find_by(plaid_id: txn.transaction_id)

        if db_txn.settled_transaction.present?
          if added_ids.include? txn.transaction_id
            added -= 1
          else
            modified -= 1
          end

          settled += 1
        else
          db_txn.destroy

          removed += 1
        end
      end

      update!(transaction_cursor: all_data[:next_cursor])
    end

    user.notifications.create!(
      source: self,
      title: "Plaid sync completed for #{name}",
      content: <<-MSG
        Plaid transactions were just synced for all accounts from #{name}.
        #{pluralize(added, "transaction")} #{added == 1 ? "was" : "were"} added,
        #{pluralize(settled, "transaction")} #{settled == 1 ? "was" : "were"} settled,
        #{pluralize(modified, "transaction")} #{modified == 1 ? "was" : "were"} modified, and
        #{pluralize(removed, "transaction")} #{removed == 1 ? "was" : "were"} removed.
      MSG
    )
  end

  def refresh_plaid_transactions
    PlaidService.refresh_transactions(access_token)
  end

  private

  private

  def fetch_new_sync_data(initial_cursor, retries_left: 3)
    all_data = {
      added: [],
      removed: [],
      modified: [],
      next_cursor: initial_cursor
    }

    if retries_left <= 0
      Rails.logger.error "fetch_new_sync_data: too many retries"
      return all_data
    end

    begin
      keep_going = false

      begin
        results = PlaidService.sync_transactions(access_token, cursor: all_data[:next_cursor])
        all_data[:added] += results.added
        all_data[:removed] += results.removed
        all_data[:modified] += results.modified
        all_data[:next_cursor] = results.next_cursor
        keep_going = results.has_more
      end while keep_going

      all_data
    rescue e
      Rails.error.log e
      fetch_new_sync_data(initial_cursor, retries_left - 1)
    end
  end

  def fetch_plaid_metadata
    item_data = PlaidService.get_item_data(access_token)

    update!(name: item_data.institution_name)

    plaid_accounts = PlaidService.get_item_accounts(access_token)

    plaid_accounts.each do |account|
      accounts.create!(account_type: account.subtype, mask: account.mask, name: account.name, plaid_id: account.account_id)
    end
  end
end
