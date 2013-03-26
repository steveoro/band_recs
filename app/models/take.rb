class Take < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :recording
  validates_associated :recording

  belongs_to :song
  validates_associated :song

  validates_presence_of :ordinal
  validates_presence_of :vote

  validates_numericality_of :ordinal, :with => /[0123456789]/, :message => :must_be_a_number_from_0_to_99
  validates_numericality_of :vote, :with => /[0123456789]/, :message => :must_be_a_number_from_0_to_99

  belongs_to :user
  # [Steve, 20120212] Validating le_user fails always because of validation requirements inside User (password & salt)
#  validates_associated :le_user                    # (Do not enable this for User)
  validates_presence_of :user_id


  # [20120809] This works only with Netzke components, for :scope (when take is an association column)
  # and with :sorting_scope (when a field of take is the column to be sorted).
  # Scopes to be used with Netzke :scope always do not have parameters:
  scope :netzke_sort_take_by_rec_code_asc,      lambda { includes( :recording ).joins( :recording ).order("recordings.rec_code, ordinal") }
  scope :netzke_sort_take_by_rec_code,          lambda { |dir| order("recordings.rec_code #{dir.to_s}, ordinal #{dir.to_s}") }
  scope :netzke_sort_take_by_song,              lambda { |dir| order("songs.name #{dir.to_s}") }
  # ---------------------------------------------------------------------------

  def base_uri
    takes_path( self )
  end

  # Computes a descriptive name associated with this data
  def get_full_name
    "#{self.recording.rec_code}-#{sprintf("%02i", self.ordinal.to_i)}-#{get_song_name} (#{I18n.t(:vote)}:#{self.vote})"
  end

  # Retrieves all the tags associated with this Take instance and produces a string
  # list of tag names, separated by comma (',').
  def get_tags
    tag4take = Tag4Take.where( :take_id => self.id )
    tag4take.collect{ |row| Tag.find(row.tag_id).name }.sort.join(',')
  end

  # Retrieves safely the song name (it could be nil)
  def get_song_name
    self.song ? "#{self.song.name}" : ""
  end
end
