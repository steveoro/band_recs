class UpdateAccessForWhosOnline < ActiveRecord::Migration
  def up
    say "adding access restrictions for 'Who's on-line' action"

    AppParameter.transaction do                     # -- START TRANSACTION --
      ap = AppParameter.find_by_code( AppParameter::PARAM_BLACKLIST_ACCESS_START )
      if (ap.nil?)
        AppParameter.create :code => AppParameter::PARAM_BLACKLIST_ACCESS_START,
                            :controller_name => 'welcome',
                            :action_name => 'whos_online',
                            :a_integer => 8,        # (almost same level as sys.admin...)
                            :description => '(controller_name, action_name): action identifiers; a_integer: required level for access grant (should be greater than base level required for controller access)'
      end

                                                    # (Let's say 5 is enough as a step in between action restrictions - it won't be read or needed anywhere else)
      ap = AppParameter.find_by_code( AppParameter::PARAM_BLACKLIST_ACCESS_START + 5 )
      if (ap.nil?)
        AppParameter.create :code => AppParameter::PARAM_BLACKLIST_ACCESS_START + 5,
                            :controller_name => 'welcome',
                            :action_name => 'edit_current_user',
                            :a_integer => 1,
                            :description => '(controller_name, action_name): action identifiers; a_integer: required level for access grant (should be greater than base level required for controller access)'
      end
    end                                             # -- END TRANSACTION --

    say 'verifying the existence of the parameters...'
    [
      AppParameter::PARAM_BLACKLIST_ACCESS_START,
      AppParameter::PARAM_BLACKLIST_ACCESS_START + 5
    ].each { |code|
      say "seeking param. row w/ code #{code}"
      raise "Parameter row not found with code #{code}!" unless AppParameter.find_by_code( code )
    }
    say 'done.'
  end


  def down
    say "deleting access restrictions for 'Who's on-line' action"
    AppParameter.delete_all(
      "(code >= #{AppParameter::PARAM_BLACKLIST_ACCESS_START}) AND (code <= #{AppParameter::PARAM_BLACKLIST_ACCESS_START + 5})"
    )
    say 'done.'
  end
end
