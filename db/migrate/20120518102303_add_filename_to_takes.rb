class AddFilenameToTakes < ActiveRecord::Migration
  def change
    add_column :takes, :file_name, :string
  end
end
