class Band < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  has_many :musician4_bands

  validates_presence_of :name
  validates_length_of :name, :within => 1..80
  validates_uniqueness_of :name, :message => :already_exists

  # FIXME Netzke gives a nil on foreign key association while creating anything based on this model if the following is not commented out: (with :musician4_bands still empty)
  # TODO Do we really need to find a way to make it work even with empty pass-through table?
#  has_many :musicians, :through => :musician4_bands

  belongs_to :user
  # [Steve, 20120212] Validating user fails always because of validation requirements inside User (password & salt)
#  validates_associated :user                    # (Do not enable this for User)
  validates_presence_of :user_id


  # [20120809] This works only with Netzke components, for defining a :scope (when band is an association column):
  scope :netzke_sort_band_by_name_asc,         lambda { order("bands.name") }
  # ---------------------------------------------------------------------------

  def base_uri
    bands_path( self )
  end
end
