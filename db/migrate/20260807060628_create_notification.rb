class CreateNotification < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications do |t|
      t.belongs_to :source, polymorphic: true
      t.belongs_to :user, null: false

      t.string :title
      t.string :content

      t.string :aasm_state, null: false, default: "pending"

      t.datetime :sent_at
      t.datetime :read_at
      t.datetime :dismissed_at

      t.timestamps
    end
  end
end
