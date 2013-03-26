class Recording < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  belongs_to :band
  validates_associated :band

  validates_presence_of :rec_code
  validates_length_of :rec_code, :within => 1..40
  validates_uniqueness_of :rec_code, :scope => :band_id, :message => :already_exists

  validates_presence_of :rec_date

  has_many :takes
  has_many :musician4_recordings

  belongs_to :user
  # [Steve, 20120212] Validating user fails always because of validation requirements inside User (password & salt)
#  validates_associated :_user                    # (Do not enable this for User)
  validates_presence_of :user_id


  # [20120809] This works only with Netzke components, for :scope (when recording is an association column)
  # and with :sorting_scope (when a field of recording is the column to be sorted):
  scope :netzke_sort_recording_by_rec_code_asc,   lambda { includes( :takes ).joins( :takes ).order("recordings.rec_code, takes.ordinal") }
  # [20120809 Parametric scopes are used only in :sorting_scope, not in :scope]
  scope :netzke_sort_recording_by_rec_code,       lambda { |dir| order("recordings.rec_code #{dir.to_s}") }
  scope :netzke_sort_recording_by_band,           lambda { |dir| order("bands.name #{dir.to_s}") }
  # ---------------------------------------------------------------------------

  def base_uri
    recordings_path( self )
  end
end
