# == Schema Information
#
# Table name: categories
#
#  id          :integer          not null, primary key
#  custom_name :string
#  plaid_name  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Category < ApplicationRecord
  has_many :transactions
  has_many :users, through: :transactions

  def display_name
    custom_name.presence || plaid_name.humanize
  end

  def transactions_by_user(user)
    transactions.joins(:account).where("accounts.user_id = ?", user.id)
  end
end
