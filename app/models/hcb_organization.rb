# == Schema Information
#
# Table name: hcb_organizations
#
#  id         :integer          not null, primary key
#  deleted_at :datetime
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  hcb_id     :string           not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_hcb_organizations_on_user_id  (user_id)
#
class HcbOrganization < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  has_one :account, dependent: :destroy
  has_many :transactions, through: :account

  after_create :fetch_hcb_metadata
  after_create :sync_hcb_transactions

  def sync_hcb_transactions
    synced_transactions = HcbService.get_organization_transactions(hcb_id)

    txn_ids = []

    ActiveRecord::Base.transaction do
      synced_transactions.each do |hcb_txn|
        existing_txn = transactions.find_by(hcb_id: hcb_txn["id"])

        if existing_txn.present?
          existing_txn.update!(hcb_object: hcb_txn)
        else
          Transaction.create_from_hcb_object(self, hcb_txn)
        end

        txn_ids.push(hcb_txn["id"])
      end

      removed_txns = account.transactions.where.not(hcb_id: txn_ids)
      removed_txns.each(&:destroy)
    end
  end

  private

  def fetch_hcb_metadata
    organization_data = HcbService.get_organization(hcb_id)

    update!(name: organization_data["name"])

    Account.create!(user:, hcb_organization: self, account_type: "restricted fund", mask: organization_data["slug"], name: organization_data["name"])
  end
end
