class MusiciansController < ApplicationController

  # Require authorization before invoking any of this controller's actions:
  before_filter :authorize


  # Default action
  def index
    @user_id = current_user.id
  end
  # ---------------------------------------------------------------------------
end
