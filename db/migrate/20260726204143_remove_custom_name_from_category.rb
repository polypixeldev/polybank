class RemoveCustomNameFromCategory < ActiveRecord::Migration[8.1]
  def up
    add_column :categories, :name, :string

    Category.all.each do |category|
      category.update!(name: category.custom_name.presence || category.plaid_name)
    end

    remove_column :categories, :custom_name, :string
    remove_column :categories, :plaid_name, :string
  end

  def down
    add_column :categories, :custom_name, :string
    add_column :categories, :plaid_name, :string

    Category.all.each do |category|
      category.update!(plaid_name: category.name)
    end

    remove_column :categories, :name, :string
  end
end
