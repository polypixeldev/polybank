class AddCustomNameToCounterparty < ActiveRecord::Migration[8.1]
  def up
    add_column :counterparties, :plaid_name, :string
    add_column :counterparties, :custom_name, :string

    Counterparty.all.each do |counterparty|
      counterparty.update!(plaid_name: counterparty.name)
    end

    remove_column :counterparties, :name, :string
  end

  def down
    add_column :counterparties, :name, :string

    Counterparty.all.each do |counterparty|
      counterparty.update!(name: counterparty.plaid_name)
    end

    remove_column :counterparties, :plaid_name, :string
    remove_column :counterparties, :custom_name, :string
  end
end
