# == Schema Information
#
# Table name: shares
#
#  id          :integer          not null, primary key
#  expires_at  :datetime
#  public      :boolean          default(FALSE), not null
#  target_type :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  target_id   :integer          not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_shares_on_target   (target_type,target_id)
#  index_shares_on_user_id  (user_id)
#
class Share < ApplicationRecord
  include Hashid::Rails

  belongs_to :user
  belongs_to :target, polymorphic: true

  has_many :share_permissions, class_name: "Share::Permission"
  has_many :shared_users, through: :share_permissions, source: :user

  scope :active, -> { where("expires_at IS NULL OR ? < expires_at", Time.now) }
  scope :inactive, -> { where("? >= expires_at", Time.now) }

  def active?
    expires_at.nil? || Time.now < expires_at
  end

  def inactive?
    !active?
  end

  def target_path
    Rails.application.routes.url_helpers.url_for([ target, only_path: true ])
  end

  def target_gid
    target&.to_global_id
  end

  def target_gid=(gid)
    self.target = GlobalID::Locator.locate gid
  end
end
