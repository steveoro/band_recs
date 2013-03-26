class AddDefaultTags < ActiveRecord::Migration
  def up
    say 'Adding default Tags...'
    Tag.transaction do                              # -- START TRANSACTION --
      Tag.create!([
          { :name => 'ascoltabile', :user_id=>1 }, { :name => 'buonina', :user_id=>1 }, { :name => 'catarro', :user_id=>1 },
          { :name => 'vergogna', :user_id=>1 }, { :name => 'rock', :user_id=>1 }, { :name => 'folk', :user_id=>1 },
          { :name => 'blues', :user_id=>1 }, { :name => 'pop', :user_id=>1 }, { :name => 'jazz', :user_id=>1 },
          { :name => 'reggae', :user_id=>1 },
          { :name => 'gruppo:completo', :user_id=>1 },
          { :name => 'gruppo:duo', :user_id=>1 },
          { :name => 'gruppo:trio', :user_id=>1 }
      ])
    end
  end


  def down
    say 'Deleting all Tags...'
    Tag.delete_all
  end
end
