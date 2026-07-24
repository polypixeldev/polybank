# == Schema Information
#
# Table name: accounts
#
#  id            :integer          not null, primary key
#  account_type  :string           not null
#  mask          :string
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  plaid_id      :string
#  plaid_item_id :integer
#  user_id       :integer
#
# Indexes
#
#  index_accounts_on_plaid_item_id  (plaid_item_id)
#  index_accounts_on_user_id        (user_id)
#
class Account < ApplicationRecord
  belongs_to :plaid_item, optional: true
  belongs_to :user

  has_many :transactions

  validate :plaid_item_belongs_to_user

  def balance
    @balance ||= if plaid_item.present?
      item_accounts = PlaidService.get_item_accounts(plaid_item.access_token)
      account_data = item_accounts.find { |a| a.account_id == plaid_id }

      account_data.balances.current
    else
      transactions.sum(:amount_cents)
    end
  end

  private

  def plaid_item_belongs_to_user
    if plaid_item&.user != user
      errors.add(:plaid_item, "must belong to user")
    end
  end
end
