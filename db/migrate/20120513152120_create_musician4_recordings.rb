class CreateMusician4Recordings < ActiveRecord::Migration
  def change
    create_table :musician4_recordings do |t|
      t.timestamps
      t.integer :recording_id,  :null => false
      t.integer :musician_id,   :null => false
    end

    add_index :musician4_recordings, ["recording_id", "musician_id"], :name => "recording_id_musician_id", :unique => true
    add_index :musician4_recordings, ["recording_id"], :name => "recording_id"
    add_index :musician4_recordings, ["musician_id"], :name => "musician_id"
  end
end
