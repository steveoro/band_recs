class Author < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  validates_presence_of :name
  validates_length_of :name, :within => 1..100

  belongs_to :user
  # [Steve, 20120212] Validating user fails always because of validation requirements inside User (password & salt)
#  validates_associated :user                    # (Do not enable this for User)
  validates_presence_of :user_id


  # [20120809] This works only with Netzke components, for :scope (when author is an association column)
  # and with :sorting_scope (when a field of author is the column to be sorted):
  scope :netzke_sort_author_by_name,             lambda { |dir| order("authors.name #{dir.to_s}") }
  # ---------------------------------------------------------------------------


  def base_uri
    authors_path( self )
  end
end
