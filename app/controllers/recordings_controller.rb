class RecordingsController < ApplicationController

  # Require authorization before invoking any of this controller's actions:
  before_filter :authorize


  # Default action
  def index
  end
  # ---------------------------------------------------------------------------


  # Manage a single recording row using +id+ as parameter
  #
  def manage
#    logger.debug( "*** Manage Recording ID: #{params[:id]}" )
    @recording_id = params[:id]
  end
end
