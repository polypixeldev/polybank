# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Category < ApplicationRecord
  include Budgetable

  has_many :transactions
  has_many :users, through: :transactions

  def display_name
    name.humanize
  end

  def transactions_by_user(user)
    transactions.joins(:account).where("accounts.user_id = ?", user.id)
  end

  def amount_by_user(user)
    transactions_by_user(user).sum(:amount_cents) / 100.0
  end

  alias_method :budgetable_transactions, :transactions_by_user
end
