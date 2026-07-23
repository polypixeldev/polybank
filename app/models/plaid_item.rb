# == Schema Information
#
# Table name: plaid_items
#
#  id           :integer          not null, primary key
#  access_token :string           not null
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

  encrypts :access_token
end
