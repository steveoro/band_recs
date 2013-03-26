class CreateTag4Takes < ActiveRecord::Migration
  def change
    create_table :tag4_takes do |t|
      t.timestamps
      t.integer :tag_id,  :null => false
      t.integer :take_id, :null => false
      t.integer :user_id, :null => false
    end

    add_index :tag4_takes, ["tag_id", "take_id"], :name => "tag_id_take_id", :unique => true
    add_index :tag4_takes, ["tag_id"], :name => "tag_id"
    add_index :tag4_takes, ["take_id"], :name => "take_id"
    add_index :tag4_takes, ["user_id"], :name => "user_id"
  end
end
