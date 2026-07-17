# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email_address      :string           not null
#  name               :string           not null
#  password_digest    :string           not null
#  plaid_access_token :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_users_on_email_address  (email_address) UNIQUE
#
class User < ApplicationRecord
  include Hashid::Rails
  include PublicIdentifiable
  set_public_id_prefix :usr

  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  encrypts :plaid_access_token

  def plaid_linked?
    plaid_access_token.present?
  end
end
