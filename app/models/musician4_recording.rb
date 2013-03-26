class Musician4Recording < ActiveRecord::Base
  belongs_to :musician
  validates_associated :musician

  belongs_to :recording
  validates_associated :recording
end
