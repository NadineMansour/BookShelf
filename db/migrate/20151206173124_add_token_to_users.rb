class AddTokenToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :token, :string, after: :uid
    add_index :users, :token, unique: true
  end
end
