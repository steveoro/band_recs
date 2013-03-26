class Song < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  validates_presence_of :name
  validates_length_of :name, :within => 1..80

  belongs_to :author
  validates_associated :author

  belongs_to :user
  # [Steve, 20120212] Validating user fails always because of validation requirements inside User (password & salt)
#  validates_associated :user                    # (Do not enable this for User)
  validates_presence_of :user_id


  # [20120809] This works only with Netzke components, for :scope (when song is an association column)
  # and with :sorting_scope (when a field of song is the column to be sorted -- in this case, author_id):
  scope :netzke_sort_song_by_author,             lambda { |dir| order("authors.name #{dir.to_s}") }
  scope :netzke_sort_song_by_full_name_asc,      lambda { order("songs.name") }
  # ---------------------------------------------------------------------------


  def base_uri
    songs_path( self )
  end

  # Computes a descriptive name associated with this data
  def get_full_name
    "#{self.name} (#{self.author.name})"
  end
end
