class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.timestamps
      t.string    "name",         :limit => 40,  :null => false
      # Used for "updated_by" getter:
      t.integer   "user_id",      :limit => 8,   :null => false
    end

    add_index :tags, ["name"], :name => "name", :unique => true
    add_index :tags, ["user_id"], :name => "user_id"
  end
end
