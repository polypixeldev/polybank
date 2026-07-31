# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email_address   :string           not null
#  name            :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  plaid_id        :string
#
# Indexes
#
#  index_users_on_email_address  (email_address) UNIQUE
#
class User < ApplicationRecord
  DEMO_EMAIL = "me+demo@sfernandez.dev"

  include Hashid::Rails
  include PublicIdentifiable
  set_public_id_prefix :usr

  has_secure_password
  has_many :sessions, dependent: :destroy

  has_many :plaid_items
  has_many :accounts
  has_many :transactions, through: :accounts
  has_many :counterparties, -> { distinct }, through: :transactions
  has_many :categories, -> { distinct }, through: :transactions
  has_many :tags

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  after_create_commit :create_plaid_user

  def self.demo_user
    u = User.find_by(email_address: DEMO_EMAIL)

    return u if u.present?

    User.create!(email_address: DEMO_EMAIL, name: "Demo User", password_digest: "password")
  end

  def plaid_linked?
    plaid_items.any?
  end

  private

  def create_plaid_user
    plaid_id = PlaidService.create_user(public_id)
    update!(plaid_id:)
  end
end
