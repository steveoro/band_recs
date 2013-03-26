class WelcomeController < ApplicationController
  include Info::UsersInfo

  require 'common/format'

  # Require authorization before invoking any of this controller's actions:
  before_filter :authorize, :except => [ :about, :contact_us, :wip ]


  def index
  end


  def about
    @versioning = AppParameter.find_by_code( AppParameter::PARAM_VERSIONING_CODE )
                                                    # Retrieve, cleanse and pre-format gem info:
    @gem_info = []
    %x{gem list -l --no-details}.split("\n").each{ |row|
      @gem_info << row if row =~ / \([0-9]/
    }
  end


  def contact_us
  end


  # Action used to allow the current user to edit its profile 
  def edit_current_user
  end


  # "Who's online" command
  #
  def whos_online
    @online_users = Info::UsersInfo.retrieve_online_users( true ) # (retrieve also full user description)
  end


  # "Work In Progress" indicator
  def wip
  end
  # ----------------------------------------------------------------------------
  #++
end
