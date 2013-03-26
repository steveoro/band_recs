class CreateMusicians < ActiveRecord::Migration
  def change
    create_table :musicians do |t|
      t.timestamps
      t.string    "name",     :limit => 80, :null => false
      t.string    "nickname", :limit => 20
      t.text      "description"
      # Used for "updated_by" getter:
      t.integer   "user_id",      :limit => 8,   :null => false
    end

    add_index :musicians, ["name"], :name => "name", :unique => true
    add_index :musicians, ["nickname"], :name => "nickname"
    add_index :musicians, ["user_id"], :name => "user_id"
  end
end
