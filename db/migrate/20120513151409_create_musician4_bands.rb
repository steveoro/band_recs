class CreateMusician4Bands < ActiveRecord::Migration
  def change
    create_table :musician4_bands do |t|
      t.timestamps
      t.integer :band_id,     :null => false
      t.integer :musician_id, :null => false
      t.datetime :joined_on
      t.datetime :left_on
      t.text :notes
    end

    add_index :musician4_bands, ["band_id", "musician_id"], :name => "band_id_musician_id", :unique => true
    add_index :musician4_bands, ["band_id"], :name => "band_id"
    add_index :musician4_bands, ["musician_id"], :name => "musician_id"
    add_index :musician4_bands, ["joined_on"], :name => "joined_on"
    add_index :musician4_bands, ["left_on"],   :name => "left_on"
  end
end
