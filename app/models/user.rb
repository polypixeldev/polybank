# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email_address   :string           not null
#  is_admin        :boolean          default(FALSE), not null
#  name            :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  hcb_id          :string
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
  has_many :budgets
  has_many :notifications
  has_many :views
  has_many :shares

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  after_create_commit :create_plaid_user

  after_update_commit :refresh_hcb_organizations, if: -> { hcb_id_previously_changed? }

  def self.demo_user
    u = User.find_by(email_address: DEMO_EMAIL)

    return u if u.present?

    User.create!(email_address: DEMO_EMAIL, name: "Demo User", password_digest: "password")
  end

  def plaid_linked?
    plaid_items.any?
  end

  def admin?
    is_admin
  end

  private

  def create_plaid_user
    return unless PlaidService.plaid_configured?

    plaid_id = PlaidService.create_user(public_id)
    update!(plaid_id:)
  end

  def refresh_hcb_organizations
    return if hcb_id.nil?

    orgs = HcbService.get_organizations
    orgs_with_user = orgs.select { |org| org["users"].any? { |u| u["id"] == hcb_id } }

    refreshed_ids = orgs_with_user.map { |org| org["id"] }
    deleted_orgs = HcbOrganization.where.not(hcb_id: refreshed_ids, user: self)
    new_org_ids = refreshed_ids.reject { |id| HcbOrganization.where(hcb_id: id).exists? }

    ActiveRecord::Base.transaction do
      deleted_orgs.each(&:destroy)

      new_org_ids.each do |id|
        HcbOrganization.create!(user: self, hcb_id: id)
      end
    end
  end
end
