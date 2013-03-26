class CreateBands < ActiveRecord::Migration
  def change
    create_table :bands do |t|
      t.timestamps
      t.string    "name",    :limit => 80, :null => false
      t.text      "description"
      t.text      "notes"
      t.datetime  "founded_on"
      t.datetime  "disbanded_on"
      # Used for "updated_by" getter:
      t.integer   "user_id",      :limit => 8,   :null => false
    end

    add_index :bands, ["name"], :name => "name", :unique => true
    add_index :bands, ["founded_on"], :name => "founded_on"
    add_index :bands, ["disbanded_on"], :name => "disbanded_on"
    add_index :bands, ["user_id"], :name => "user_id"
  end
end
