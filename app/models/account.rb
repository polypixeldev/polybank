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

      if account_type == "credit"
        account_data.balances.current
      else
        account_data.balances.available || account_data.balances.current
      end
    else
      transactions.sum(:amount_cents) / 100.0
    end
  end

  def balance_by_day
    start_date = transactions.effective.order(date: :asc).first&.date || created_at.to_date
    days = (Date.today - start_date).to_i + 1

    balances_from_start = {}

    days.times do |i|
      day = start_date + i.days

      balances_from_start[day.to_s] = transactions.effective.where("transactions.date >= ? AND transactions.date <= ?", start_date, day).sum(:amount_cents)
    end

    if plaid_item.present?
      current_balance = balance * 100
      difference = current_balance - balances_from_start[Date.today.to_s]

      balances_from_start.transform_values { |b| (b + difference) / 100.0 }
    else
      balances_from_start.transform_values { |b| b / 100.0 }
    end
  end

  private

  def plaid_item_belongs_to_user
    if plaid_item.present? && plaid_item&.user != user
      errors.add(:plaid_item, "must belong to user")
    end
  end
end
