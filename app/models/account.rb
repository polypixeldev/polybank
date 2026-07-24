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
#
# Indexes
#
#  index_accounts_on_plaid_item_id  (plaid_item_id)
#
class Account < ApplicationRecord
  belongs_to :plaid_item, optional: true

  has_many :transactions
end
