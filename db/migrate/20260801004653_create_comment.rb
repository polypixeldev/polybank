class CreateComment < ActiveRecord::Migration[8.1]
  def change
    create_table :comments do |t|
      t.string :content

      t.belongs_to :commentable, null: false, polymorphic: true
      t.belongs_to :author, null: false

      t.timestamps
    end
  end
end
