class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.timestamps
      t.string :session_id
      t.text :data
    end
  end
end
