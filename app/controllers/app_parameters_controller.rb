class AppParametersController < ApplicationController

  # Require authorization before invoking any of this controller's actions:
  before_filter :authorize


  # Default action
  def index
  end
  # ---------------------------------------------------------------------------
end
