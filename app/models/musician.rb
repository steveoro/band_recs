class Musician < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  has_many :musician4_bands
  has_many :musician4_recordings

  validates_presence_of :name
  validates_length_of :name, :within => 1..80
  validates_uniqueness_of :name, :message => :already_exists

  validates_presence_of :nickname
  validates_length_of :nickname, :within => 1..20

  belongs_to :user
  # [Steve, 20120212] Validating user fails always because of validation requirements inside User (password & salt)
#  validates_associated :user                    # (Do not enable this for User)
  validates_presence_of :user_id
  # ---------------------------------------------------------------------------


  def base_uri
    musicians_path( self )
  end

  # Computes a descriptive name associated with this data
  def get_full_name
    "#{self.nickname} (#{self.name})"
  end
end
