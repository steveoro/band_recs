class Musician4Band < ActiveRecord::Base
  belongs_to :band
  validates_associated :band

  belongs_to :musician
  validates_associated :musician


  # [20120809] This works only with Netzke components, for defining a :sorting_scope (when a field of
  # musician4_band is the column to be sorted):
  scope :netzke_sort_musician4_band_by_full_name,   lambda { |dir| order("musicians.nickname #{dir.to_s}, musicians.name #{dir.to_s}") }

  # [20120809] This works with plain ActiveRecord association, requiring an explicit join:
  # [20121121] Note: "joins" implies an INNER JOIN, whereas "includes", which is used for eager loading of associations,
  # implies a LEFT OUTER JOIN.
  scope :sort_musician4_band_by_full_name,          lambda { |dir| joins(:musician).order("musicians.nickname #{dir.to_s}, musicians.name #{dir.to_s}") }
  # ---------------------------------------------------------------------------


  # Computes a descriptive name associated with this data
  def get_full_name
    self.musician ? "#{self.musician.get_full_name}" : ""
  end
end
