# == Schema Information
#
# Table name: share_permissions
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  share_id   :integer          not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_share_permissions_on_share_id  (share_id)
#  index_share_permissions_on_user_id   (user_id)
#
class Share
  class Permission < ApplicationRecord
    belongs_to :share
    belongs_to :user
  end
end
