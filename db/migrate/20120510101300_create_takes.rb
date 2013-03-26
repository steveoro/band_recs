class CreateTakes < ActiveRecord::Migration
  def change
    create_table :takes do |t|
      t.timestamps
      t.integer   "recording_id", :limit => 8,  :null => false
      t.integer   "song_id",      :limit => 8
      t.integer   "ordinal",      :limit => 2,  :default => 0,  :null => false
      t.integer   "vote",         :limit => 2,  :default => 0,  :null => false
      t.text      "notes"
      # Used for "updated_by" getter:
      t.integer   "user_id",      :limit => 8,   :null => false
    end

    add_index :takes, ["recording_id"], :name => "recording_id"
    add_index :takes, ["song_id"], :name => "song_id"
    add_index :takes, ["ordinal"], :name => "ordinal"
    add_index :takes, ["vote"], :name => "vote"
    add_index :takes, ["user_id"], :name => "user_id"
  end
end
