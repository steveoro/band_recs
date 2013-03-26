class AddDefaultUsers < ActiveRecord::Migration
  def up
    say 'Adding default Users...'
    User.transaction do                             # -- START TRANSACTION --
      User.create!([
        { :name => 'steve', :description => 'Stefano Alloro', :password=>'password', :password_confirmation=>'password', :authorization_level=>9, :user_id=>1 },
        { :name => 'leega', :description => 'Marco Ligabue', :password=>'password', :password_confirmation=>'password', :authorization_level=>8, :user_id=>1 },
        { :name => 'guest', :description => 'Guest User', :password=>'guestuser', :password_confirmation=>'guestuser', :authorization_level=>1, :user_id=>1 },
      ])
    end
  end


  def down
    say 'Deleting all Users...'
    User.delete_all
  end
end
