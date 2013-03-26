class CreateAuthors < ActiveRecord::Migration
  def change
    create_table :authors do |t|
      t.timestamps
      t.string  :name,      :limit => 100, :null => false
      # Used for "updated_by" getter:
      t.integer :user_id,   :limit => 8,   :null => false
     end

    add_index :authors, ["name"], :name => "name"
    add_index :authors, ["user_id"], :name => "user_id"
  end
end
