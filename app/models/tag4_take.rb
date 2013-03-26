class Tag4Take < ActiveRecord::Base
  belongs_to :tag
  validates_associated :tag

  belongs_to :take
  validates_associated :take

  belongs_to :user
  validates_presence_of :user_id


  # [20120809] This works only with Netzke components, for :sorting_scope (when tag4_take.take is the column to be sorted):
  scope :netzke_sort_tag4_take_by_take_full_name,   lambda { |dir| includes( :take => :recording ).joins( :take => :recording ).order("recordings.rec_code #{dir.to_s}, takes.ordinal #{dir.to_s}") }
  # ---------------------------------------------------------------------------
end
