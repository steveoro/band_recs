class AddDefaultMusiciansAndBands < ActiveRecord::Migration
  def up
    say 'Adding default Musicians...'
    musicians = nil
    Musician.transaction do                             # -- START TRANSACTION --
      musicians = Musician.create!([
          { :name => 'Ligabue Marco', :user_id=>1, :nickname => 'Leega', :description => 'guitar1, voice' },
          { :name => 'Stefano Alloro', :user_id=>1, :nickname => 'Steve', :description => 'bass, voice, drums' },
          { :name => 'Cristian Bondi', :user_id=>1, :nickname => 'Chris', :description => 'guitar2' },
          { :name => 'Pietro Burani', :user_id=>1, :nickname => 'Peter', :description => 'guitar3' },
          { :name => 'Francesco Orlandini', :user_id=>1, :nickname => "Fra'", :description => 'keyboards' },
          { :name => 'Francesco Zacchi', :user_id=>1, :nickname => 'Zacchi', :description => 'keyboards' },
          { :name => 'Fabio', :user_id=>1, :nickname => 'Fabio', :description => 'guitar3' },
          { :name => 'Davide Formentini', :user_id=>1, :nickname => 'Forme', :description => 'bass' }
      ])
    end                                                 # -- END TRANSACTION --

    say 'Adding default Bands...'
    bands = nil
    Band.transaction do                                 # -- START TRANSACTION --
      bands = Band.create!([
          { :name => 'Leegacy', :user_id=>1, :description => 'Formazione variabile da min 2 a max 5 elementi; solitamente voce + basso + chitarre', :notes => "fondati all'incirca nel 2008 su richiesta esplicita di Leega" },
          { :name => '5 Misti', :user_id=>1, :description => 'Formazione variabile da min 2 a max 5 elementi; solitamente voce + basso + chitarre', :notes => "fondati nell'estate del 2011 con cambio di nome per supperire all'assenza di Fra' alle tastiere" }
      ])
    end                                                 # -- END TRANSACTION --
    
    puts "-- Musician4Band.transaction, bands.first: #{bands.first.id},  bands.last: #{bands.last.id}"
    musician_leega_id = musicians.find{|row| row.nickname =~ /Leega/}.id
    musician_steve_id = musicians.find{|row| row.nickname =~ /Steve/}.id
    musician_chris_id = musicians.find{|row| row.nickname =~ /Chris/}.id
    musician_peter_id = musicians.find{|row| row.nickname =~ /Peter/}.id
    musician_fra_id   = musicians.find{|row| row.nickname =~ /Fra/}.id
    # DEBUG
    # puts "Leega: #{musician_leega_id}"
    # puts "Steve: #{musician_steve_id}"
    # puts "Chris: #{musician_chris_id}"
    # puts "Peter: #{musician_peter_id}"
    # puts "Fra:   #{musician_fra_id}"

    say 'Adding default Musician4Bands...'
    Musician4Band.transaction do                        # -- START TRANSACTION --
      Musician4Band.create!([
          {
            :band_id     => bands.first.id,
            :musician_id => musician_leega_id
          },
          {
            :band_id     => bands.first.id,
            :musician_id => musician_steve_id
          },
          {
            :band_id     => bands.first.id,
            :musician_id => musician_chris_id
          },
          {
            :band_id     => bands.first.id,
            :musician_id => musician_peter_id
          },
          {
            :band_id     => bands.first.id,
            :musician_id => musician_fra_id
          },
          # [Steve, 20120517] Above we tried a more debuggable approach, because we had an issue with a mis-configured has_many..through clause in musician4_bands
          # (But the following should suffice.)
    
          {
            :band     => bands.last,
            :musician => musicians.find{|row| row.nickname =~ /Leega/}
          },
          {
            :band     => bands.last,
            :musician => musicians.find{|row| row.nickname =~ /Steve/}
          },
          {
            :band     => bands.last,
            :musician => musicians.find{|row| row.nickname =~ /Chris/}
          },
          {
            :band     => bands.last,
            :musician => musicians.find{|row| row.nickname =~ /Peter/}
          },
          {
            :band     => bands.last,
            :musician => musicians.find{|row| row.nickname =~ /Zacchi/}
          },
          {
            :band     => bands.last,
            :musician => musicians.find{|row| row.nickname =~ /Forme/},
            :notes    => "Guest star acquisito in formazione in occasione della Cena per il decenalle del gruppo Master, il 20-07-2011"
          },
          {
            :band     => bands.last,
            :musician => musicians.find{|row| row.nickname =~ /Fabio/},
            :notes    => "Entrato in formazione dalla Primavera 2012 per ovviare alla costante assenza di Pietro"
          }
      ])
    end                                                 # -- END TRANSACTION --
  end


  def down
    say 'Deleting all Musician4Bands...'
    Musician4Band.delete_all
    say 'Deleting all Bands...'
    Band.delete_all
    say 'Deleting all Musicians...'
    Musician.delete_all
  end
end
