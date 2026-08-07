# == Schema Information
#
# Table name: notifications
#
#  id           :integer          not null, primary key
#  aasm_state   :string           default("pending"), not null
#  content      :string
#  dismissed_at :datetime
#  key          :string
#  read_at      :datetime
#  sent_at      :datetime
#  source_type  :string
#  title        :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  source_id    :integer
#  user_id      :integer          not null
#
# Indexes
#
#  index_notifications_on_source   (source_type,source_id)
#  index_notifications_on_user_id  (user_id)
#
class Notification < ApplicationRecord
  include AASM

  belongs_to :user
  belongs_to :source, polymorphic: true, optional: true

  scope :sent_or_read, -> { where(aasm_state: [ "sent", "read" ]) }

  validates :key, uniqueness: { scope: :user_id }

  aasm timestamps: true do
    state :pending
    state :sent
    state :read
    state :dismissed

    event :mark_sent do
      transitions from: :pending, to: :sent
    end

    event :mark_read do
      transitions from: :sent, to: :read
    end

    event :mark_dismissed do
      transitions from: [ :sent, :read ], to: :dismissed
    end
  end

  after_create_commit :send!

  def send!
    # TODO: Send via email

    mark_sent!
  end

  def source_url
    Rails.application.routes.url_helpers.url_for(source)
  end
end
