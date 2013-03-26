class CreateSongs < ActiveRecord::Migration
  def change
    create_table :songs do |t|
      t.timestamps
      t.string    "name",       :limit => 80, :null => false
      t.integer   "author_id",  :limit => 8,  :null => false
      # Used for "updated_by" getter:
      t.integer   "user_id",    :limit => 8,   :null => false
    end

    add_index :songs, ["name"], :name => "name"
    add_index :songs, ["author_id"], :name => "author_id"
    add_index :songs, ["user_id"], :name => "user_id"
  end
end
