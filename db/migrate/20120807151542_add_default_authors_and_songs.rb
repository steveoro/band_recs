class AddDefaultAuthorsAndSongs < ActiveRecord::Migration
  def up
    say 'Adding default Authors...'
    authors = nil
    Author.transaction do                           # -- START TRANSACTION --
      authors = Author.create!([
          { :name => 'Bob Dylan', :user_id=>1 },
          { :name => 'Bob Marley', :user_id=>1 },
          { :name => 'Creedence Clearwater Revival', :user_id=>1 },
          { :name => 'Lynyrd Skynyrd', :user_id=>1 },
          { :name => 'The Animals', :user_id=>1 },
          { :name => 'Rolling Stones', :user_id=>1 },
          { :name => 'Eric Clapton', :user_id=>1 },
          { :name => 'Jimi Hendrix', :user_id=>1 },
          { :name => 'The Blues Brothers', :user_id=>1 },
          { :name => 'Ray Charles', :user_id=>1 },
          { :name => 'The Doors', :user_id=>1 },
          { :name => 'Pink Floyd', :user_id=>1 },
          { :name => 'Jethro Tull', :user_id=>1 },
          { :name => 'David Bowie', :user_id=>1 },
          { :name => 'Deep Purple', :user_id=>1 },
          { :name => 'The Who', :user_id=>1 },
          { :name => 'Mike Oldfield', :user_id=>1 },
          { :name => 'Bruce Springsteen', :user_id=>1 },
          { :name => 'The Waterboys', :user_id=>1 },
          { :name => 'Max Frost & The Troopers', :user_id=>1 },
          { :name => 'Eddie Vedder', :user_id=>1 },
          { :name => 'Ben E. King', :user_id=>1 },
          { :name => 'Neil Young', :user_id=>1 },
          { :name => 'Dire Straits', :user_id=>1 },
          { :name => 'Eagles', :user_id=>1 },
          { :name => 'Sting', :user_id=>1 },
          { :name => 'David Coverdale', :user_id=>1 },
          { :name => 'The Beatles', :user_id=>1 },
          { :name => 'Doobie Brothers', :user_id=>1 }
      ])
    end                                             # -- END TRANSACTION --

    say 'Adding default Songs...'
    songs = nil
    Song.transaction do                             # -- START TRANSACTION --
      songs = Song.create!([
          { :name => 'Angie', :user_id=>1, :author => authors.find{|row| row.name =~ /Rolling Stones/} },
          { :name => 'Everybody Needs Somebody', :user_id=>1, :author => authors.find{|row| row.name =~ /Blues Brothers/} },
          { :name => 'Sweet Home Chicago', :user_id=>1, :author => authors.find{|row| row.name =~ /Blues Brothers/} },
          { :name => 'Simple Man', :user_id=>1, :author => authors.find{|row| row.name =~ /Lynyrd/} },
          { :name => 'Hit The Road Jack', :user_id=>1, :author => authors.find{|row| row.name =~ /Ray Charles/} },
          { :name => 'I Shot The Sheriff', :user_id=>1, :author => authors.find{|row| row.name =~ /Bob Marley/} },
          { :name => 'Redemption Song', :user_id=>1, :author => authors.find{|row| row.name =~ /Bob Marley/} },
          { :name => 'Break On Through', :user_id=>1, :author => authors.find{|row| row.name =~ /The Doors/} },
          { :name => 'Love Me Two Times', :user_id=>1, :author => authors.find{|row| row.name =~ /The Doors/} },
          { :name => 'Hello, I Love You', :user_id=>1, :author => authors.find{|row| row.name =~ /The Doors/} },
          { :name => 'Money', :user_id=>1, :author => authors.find{|row| row.name =~ /Pink Floyd/} },
          { :name => 'Wish You Were Here', :user_id=>1, :author => authors.find{|row| row.name =~ /Pink Floyd/} },
          { :name => 'Fragile', :user_id=>1, :author => authors.find{|row| row.name =~ /Sting/} },
          { :name => 'Wonderful Tonight', :user_id=>1, :author => authors.find{|row| row.name =~ /Eric Clapton/} },
          { :name => 'Layla', :user_id=>1, :author => authors.find{|row| row.name =~ /Eric Clapton/} },
          { :name => 'Wind Up', :user_id=>1, :author => authors.find{|row| row.name =~ /Jethro Tull/} },
          { :name => 'We Gotta Get Out Of This Place', :user_id=>1, :author => authors.find{|row| row.name =~ /Animals/} },
          { :name => 'House Of The Rising Sun', :user_id=>1, :author => authors.find{|row| row.name =~ /Animals/} },
          { :name => 'Gonna Send You Back To Walker', :user_id=>1, :author => authors.find{|row| row.name =~ /Animals/} },
          { :name => 'Lucille', :user_id=>1, :author => authors.find{|row| row.name =~ /Deep Purple/} },
          { :name => "Anyone's Daughter", :user_id=>1, :author => authors.find{|row| row.name =~ /Deep Purple/} },
          { :name => 'Bad Moon Rising', :user_id=>1, :author => authors.find{|row| row.name =~ /Creedence/} },
          { :name => 'Have You Ever Seen The Rain', :user_id=>1, :author => authors.find{|row| row.name =~ /Creedence/} },
          { :name => 'Lodi', :user_id=>1, :author => authors.find{|row| row.name =~ /Creedence/} },
          { :name => 'Proud Mary', :user_id=>1, :author => authors.find{|row| row.name =~ /Creedence/} },
          { :name => 'Down On The Corner', :user_id=>1, :author => authors.find{|row| row.name =~ /Creedence/} },
          { :name => 'The Seeker', :user_id=>1, :author => authors.find{|row| row.name =~ /Who/} },
          { :name => 'Space Oddity', :user_id=>1, :author => authors.find{|row| row.name =~ /Bowie/} },
          { :name => 'Shape Of Things To Come', :user_id=>1, :author => authors.find{|row| row.name =~ /Max Frost/} },
          { :name => 'Society', :user_id=>1, :author => authors.find{|row| row.name =~ /Vedder/} },
          { :name => 'Stand By Me', :user_id=>1, :author => authors.find{|row| row.name =~ /Ben E. King/} },
          { :name => 'Keep On Rocking In The Free World', :user_id=>1, :author => authors.find{|row| row.name =~ /Neil Young/} },
          { :name => "Knocking On Heaven's Door", :user_id=>1, :author => authors.find{|row| row.name =~ /Bob Dylan/} },
          { :name => 'Sultans of Swing', :user_id=>1, :author => authors.find{|row| row.name =~ /Dire Straits/} },
          { :name => 'Hotel California', :user_id=>1, :author => authors.find{|row| row.name =~ /Eagles/} },
          { :name => 'Moonlight Shadow', :user_id=>1, :author => authors.find{|row| row.name =~ /Oldfield/} },
          { :name => 'Soldier of Fortune', :user_id=>1, :author => authors.find{|row| row.name =~ /Coverdale/} },
          { :name => 'Ghost of Tom Jode', :user_id=>1, :author => authors.find{|row| row.name =~ /Springsteen/} },
          { :name => 'Eleanor Rigby', :user_id=>1, :author => authors.find{|row| row.name =~ /Beatles/} },
          { :name => 'Long Train Running', :user_id=>1, :author => authors.find{|row| row.name =~ /Doobie/} }
      ])
    end                                             # -- END TRANSACTION --
  end


  def down
    say 'Deleting all Songs...'
    Song.delete_all
    say 'Deleting all Authors...'
    Author.delete_all
  end
end
