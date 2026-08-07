# == Schema Information
#
# Table name: views
#
#  id              :integer          not null, primary key
#  direction       :string
#  end_date        :date
#  max_amount      :integer
#  memo            :string
#  min_amount      :integer
#  name            :string
#  start_date      :date
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  account_id      :integer
#  category_id     :integer
#  counterparty_id :integer
#  tag_id          :integer
#  user_id         :integer          not null
#
# Indexes
#
#  index_views_on_account_id       (account_id)
#  index_views_on_category_id      (category_id)
#  index_views_on_counterparty_id  (counterparty_id)
#  index_views_on_tag_id           (tag_id)
#  index_views_on_user_id          (user_id)
#
class View < ApplicationRecord
  belongs_to :user

  belongs_to :account, optional: true
  belongs_to :category, optional: true
  belongs_to :counterparty, optional: true
  belongs_to :tag, optional: true

  def transactions
    Transaction.apply_filters(user.transactions.effective, {
      memo:,
      start_date:,
      end_date:,
      account:,
      category:,
      counterparty:,
      tag:,
      min_amount:,
      max_amount:,
      direction:
  }.compact)
  end

  def amount_cents
    transactions.sum(&:amount_cents)
  end

  def amount
    amount_cents / 100.0
  end
end
