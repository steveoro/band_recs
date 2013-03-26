class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.timestamps
      t.string  :name, :null => false
      t.string  :description
      t.string  :hashed_pwd
      t.string  :salt
      t.integer :authorization_level
      # Used for "updated_by" getter:
      t.integer :user_id,    :limit => 8,   :null => false
    end

    add_index :users, ["name"], :name => "name", :unique => true
    add_index :users, ["user_id"], :name => "user_id"
  end
end
