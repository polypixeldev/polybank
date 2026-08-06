# == Schema Information
#
# Table name: tags
#
#  id         :integer          not null, primary key
#  color      :string           not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_tags_on_user_id  (user_id)
#
class Tag < ApplicationRecord
  include Budgetable

  belongs_to :user

  has_many :tag_transactions
  has_many :transactions, through: :tag_transactions, source: :associated_transaction

  def amount
    @amount ||= transactions.effective.sum(:amount_cents) / 100.0
  end

  def budgetable_transactions(user)
    return [] if user != self.user

    transactions
  end
end
