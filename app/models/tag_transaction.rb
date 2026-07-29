# == Schema Information
#
# Table name: tag_transactions
#
#  id             :integer          not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  tag_id         :integer          not null
#  transaction_id :integer          not null
#
# Indexes
#
#  index_tag_transactions_on_tag_id          (tag_id)
#  index_tag_transactions_on_transaction_id  (transaction_id)
#
class TagTransaction < ApplicationRecord
  belongs_to :tag
  belongs_to :associated_transaction, foreign_key: :transaction_id, class_name: "Transaction"

  validate :tag_transaction_user_matches

  private

  def tag_transaction_user_matches
    if tag.user != associated_transaction.user
      errors.add(:base, "tag user and transaction user must match")
    end
  end
end
