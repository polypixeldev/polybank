class AccountsController < ApplicationController
  before_action :set_account, only: [ :show ]

  def show
    authorize @account
  end

  def generate_demo
    skip_authorization

    ActiveRecord::Base.transaction do
      account = current_user.accounts.create!(account_type: :savings, mask: "0000", name: "PolyBank Savings")

      categories = []
      5.times do
        categories.push Category.create!(
          name: Faker::Company.industry
        )
      end

      5.times do
      account.transactions.create!(
          amount_cents: rand(10000..100000),
          category: categories.sample,
          currency: "USD",
          date: Faker::Date.between(from: 1.year.ago, to: Date.today),
          memo: "PAY INVOICE #{Faker::Invoice.reference}",
          pending: false
        )
      end

      spending = []
      20.times do
        spending.push account.transactions.create!(
          amount_cents: -rand(50..10000),
          category: categories.sample,
          currency: "USD",
          date: Faker::Date.between(from: 1.year.ago, to: Date.today),
          memo: "#{Faker::Commerce.brand} #{Faker::Commerce.product_name} (#{Faker::Commerce.color})",
          pending: rand(0..5) == 0
        )
      end

      10.times do
        c = Counterparty.create!(
          counterparty_type: "merchant",
          plaid_name: Faker::Company.name
        )

        transactions = spending.sample(2)

        c.transactions << transactions.first
        c.transactions << transactions.second
      end
    end
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end
end
