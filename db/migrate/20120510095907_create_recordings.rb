class CreateRecordings < ActiveRecord::Migration
  def change
    create_table :recordings do |t|
      t.timestamps
      t.string    "rec_code",     :limit => 80,  :null => false
      t.integer   "band_id",      :limit => 8,   :null => false
      t.datetime  "rec_date",     :null => false
      t.integer   "rec_order",    :default => 0
      t.string    "description"
      t.text      "notes"
      # Used for "updated_by" getter:
      t.integer   "user_id",      :limit => 8,   :null => false
    end

    add_index :recordings, ["rec_code"], :name => "rec_code", :unique => true
    add_index :recordings, ["rec_date"], :name => "rec_date"
    add_index :recordings, ["rec_date", "rec_order"], :name => "rec_date_order"
    add_index :recordings, ["band_id"], :name => "band_id"
    add_index :recordings, ["user_id"], :name => "user_id"
  end
end
