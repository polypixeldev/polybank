class CreateHcbOrganization < ActiveRecord::Migration[8.1]
  def change
    create_table :hcb_organizations do |t|
      t.string :hcb_id, null: false
      t.string :name

      t.datetime :deleted_at

      t.belongs_to :user, null: false
      t.timestamps
    end
  end
end
