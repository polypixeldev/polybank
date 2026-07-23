# == Schema Information
#
# Table name: plaid_items
#
#  id           :integer          not null, primary key
#  access_token :string           not null
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  item_id      :string           not null
#  user_id      :integer          not null
#
# Indexes
#
#  index_plaid_items_on_user_id  (user_id)
#
class PlaidItem < ApplicationRecord
  belongs_to :user
  has_many :accounts

  encrypts :access_token

  after_create :fetch_plaid_data

  private

  def fetch_plaid_data
    item_data = PlaidService.get_item_data(access_token)

    update!(name: item_data.institution_name)

    plaid_accounts = PlaidService.get_item_accounts(access_token)

    plaid_accounts.each do |account|
      accounts.create!(account_type: account.subtype, mask: account.mask, name: account.name, plaid_id: account.account_id)
    end
  end
end
