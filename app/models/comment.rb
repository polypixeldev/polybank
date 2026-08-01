# == Schema Information
#
# Table name: comments
#
#  id               :integer          not null, primary key
#  commentable_type :string           not null
#  content          :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  author_id        :integer          not null
#  commentable_id   :integer          not null
#
# Indexes
#
#  index_comments_on_author_id    (author_id)
#  index_comments_on_commentable  (commentable_type,commentable_id)
#
class Comment < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :commentable, polymorphic: true
end
