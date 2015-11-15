class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :timeline, index: true, foreign_key: true
      t.string :book
      t.string :author
      t.string :content
      t.string :genre

      t.timestamps null: false
    end
  end
end
