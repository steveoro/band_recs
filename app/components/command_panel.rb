#
# == Main Command Panel / Menu Toolbar component implementation
#
# - author: Steve A.
# - vers. : 0.24.20121121
#
require 'netzke/core'


class CommandPanel < Netzke::Basepack::Panel

  action :authors,      :text => I18n.t(:authors, :scope =>[:agex_action]),
                        :tooltip => I18n.t(:authors_tooltip, :scope =>[:agex_action]),
                        :icon =>"/images/icons/book_open.png",
                        :disabled => Netzke::Core.current_user ? (! Netzke::Core.current_user.can_access( :authors )) : true

  action :bands,        :text => I18n.t(:bands, :scope =>[:agex_action]),
                        :tooltip => I18n.t(:bands_tooltip, :scope =>[:agex_action]),
                        :icon =>"/images/icons/group_link.png",
                        :disabled => Netzke::Core.current_user ? (! Netzke::Core.current_user.can_access( :bands )) : true

  action :musicians,    :text => I18n.t(:musicians, :scope =>[:agex_action]),
                        :tooltip => I18n.t(:musicians_tooltip, :scope =>[:agex_action]),
                        :icon =>"/images/icons/group.png",
                        :disabled => Netzke::Core.current_user ? (! Netzke::Core.current_user.can_access( :musicians )) : true

  action :recordings,   :text => I18n.t(:recordings, :scope =>[:agex_action]),
                        :tooltip => I18n.t(:recordings_tooltip, :scope =>[:agex_action]),
                        :icon =>"/images/icons/control_play_blue.png",
                        :disabled => Netzke::Core.current_user ? (! Netzke::Core.current_user.can_access( :recordings )) : true

  action :songs,        :text => I18n.t(:songs, :scope =>[:agex_action]),
                        :tooltip => I18n.t(:songs_tooltip, :scope =>[:agex_action]),
                        :icon =>"/images/icons/music.png",
                        :disabled => Netzke::Core.current_user ? (! Netzke::Core.current_user.can_access( :songs )) : true

  action :tags,         :text => I18n.t(:tags, :scope =>[:agex_action]),
                        :tooltip => I18n.t(:tags_tooltip, :scope =>[:agex_action]),
                        :icon =>"/images/icons/tag_blue.png",
                        :disabled => Netzke::Core.current_user ? (! Netzke::Core.current_user.can_access( :tags )) : true

  action :users,        :text => I18n.t(:users, :scope =>[:agex_action]),
                        :tooltip => I18n.t(:users_tooltip, :scope =>[:agex_action]),
                        :icon =>"/images/icons/user_suit.png",
                        :disabled => Netzke::Core.current_user ? (! Netzke::Core.current_user.can_access( :users )) : true

  action :app_parameters, :text => I18n.t(:app_parameters, :scope =>[:agex_action]),
                        :tooltip => I18n.t(:app_parameters_tooltip, :scope =>[:agex_action]),
                        :icon =>"/images/icons/wrench_orange.png",
                        :disabled => Netzke::Core.current_user ? (! Netzke::Core.current_user.can_access( :app_parameters )) : true

  action :index,        :text => I18n.t(:home, :scope =>[:agex_action]),
                        :tooltip => I18n.t(:home_tooltip, :scope =>[:agex_action]),
                        :icon =>"/images/icons/house_go.png",
                        :disabled => Netzke::Core.current_user ? (! Netzke::Core.current_user.can_access( :welcome )) : true

  action :about,        :text => I18n.t(:about, :scope =>[:agex_action]),
                        :tooltip => I18n.t(:about_tooltip, :scope =>[:agex_action]),
                        :icon =>"/images/icons/information.png"

  action :contact_us,   :text => I18n.t(:contact_us, :scope =>[:agex_action]),
                        :tooltip => I18n.t(:contact_us_tooltip, :scope =>[:agex_action]),
                        :icon =>"/images/icons/email.png",
                        :disabled => Netzke::Core.current_user ? (! Netzke::Core.current_user.can_access( :welcome )) : true

  action :whos_online,  :text => I18n.t(:whos_online, :scope =>[:agex_action]),
                        :tooltip => I18n.t(:whos_online_tooltip, :scope =>[:agex_action]),
                        :icon =>"/images/icons/monitor.png",
                        :disabled => Netzke::Core.current_user ? (! Netzke::Core.current_user.can_do( :welcome, :whos_online )) : true

  action :edit_current_user,
                        :text => I18n.t(:edit_current_user, :scope =>[:agex_action]),
                        :tooltip => I18n.t(:edit_current_user_tooltip, :scope =>[:agex_action]),
                        :icon =>"/images/icons/user_edit.png",
                        :disabled => Netzke::Core.current_user ? (! Netzke::Core.current_user.can_do( :welcome, :edit_current_user )) : true

  action :upload,       :text => I18n.t(:upload, :scope =>[:agex_action]),
                        :tooltip => I18n.t(:upload_tooltip, :scope =>[:agex_action]),
                        :icon =>"/images/icons/computer_go.png",
                        :disabled => true
                        # FIXME [Steve, 20120702] WIP
#                        :disabled => Netzke::Core.current_user ? (! Netzke::Core.current_user.can_access( :upload )) : true

  action :manage_files, :text => I18n.t(:manage_files, :scope =>[:agex_action]),
                        :tooltip => I18n.t(:manage_files_tooltip, :scope =>[:agex_action]),
                        :icon =>"/images/icons/folder_wrench.png",
                        :disabled => true
                        # FIXME [Steve, 20120702] WIP
#                        :disabled => Netzke::Core.current_user ? (! Netzke::Core.current_user.can_do( :upload, :manage_files )) : true

  action :logout,       :text => I18n.t(:logout, :scope =>[:agex_action]),
                        :tooltip => I18n.t(:logout_tooltip, :scope =>[:agex_action]),
                        :icon =>"/images/icons/door_out.png"
  # ---------------------------------------------------------------------------


  js_property :tbar, [
    {
      :menu => [
        :index.action,
        :about.action,
        :contact_us.action,
        "-",
        :edit_current_user.action,
        "-",
        :logout.action
      ],
      :text => I18n.t(:main, :scope =>[:agex_action]),
      :icon => "/images/icons/application_home.png"
    },
    {
      :menu => [ :bands.action, :musicians.action ],
      :text => I18n.t(:group_and_performers, :scope =>[:agex_action]),
      :icon => "/images/icons/group.png",
      :disabled => Netzke::Core.current_user ? (! Netzke::Core.current_user.can_access( :bands )) : true
    },
    {
      :menu => [ :authors.action, :songs.action ],
      :text => I18n.t(:songs_and_authors, :scope =>[:agex_action]),
      :icon => "/images/icons/book_open.png",
      :disabled => Netzke::Core.current_user ? (! Netzke::Core.current_user.can_access( :authors )) : true
    },
    {
      :menu => [ :recordings.action, :tags.action ],
      :text => I18n.t(:recordings_database, :scope =>[:agex_action]),
      :icon => "/images/icons/database_edit.png",
      :disabled => Netzke::Core.current_user ? (! Netzke::Core.current_user.can_access( :recordings )) : true
    },
    {
      :menu => [ :upload.action, "-", :manage_files.action ],
      :text => I18n.t(:audio_files),
      :icon => "/images/icons/computer_go.png",
      :disabled => Netzke::Core.current_user ? (! Netzke::Core.current_user.can_access( :upload )) : true
    },
    {
      :menu => [ :whos_online.action, :users.action, :app_parameters.action ],
      :text => I18n.t(:manage_system, :scope =>[:agex_action]),
      :icon => "/images/icons/computer.png",
      :disabled => Netzke::Core.current_user ? (! Netzke::Core.current_user.can_access( :users )) : true
    }
  ]



  js_properties(
    :prevent_header => true,
    :header => false
  )


  def configuration
    super.merge(
      :min_height => 28,
      :height => 28,
      :margin => '0'
    )
  end
  # ---------------------------------------------------------------------------


  js_method :init_component, <<-JS
    function(){
      #{js_full_class_name}.superclass.initComponent.call(this);
    }  
  JS
  # ---------------------------------------------------------------------------


  # Front-end JS event handler for the action 'authors' (index)
  #
  js_method :on_authors, <<-JS
    function(){
      location.href = "#{User.new.authors_path()}";
    }
  JS

  # Front-end JS event handler for the action 'bands' (index)
  #
  js_method :on_bands, <<-JS
    function(){
      location.href = "#{User.new.bands_path()}";
    }
  JS

  # Front-end JS event handler for the action 'musicians' (index)
  #
  js_method :on_musicians, <<-JS
    function(){
      location.href = "#{User.new.musicians_path()}";
    }
  JS

  # Front-end JS event handler for the action 'recordings' (index)
  #
  js_method :on_recordings, <<-JS
    function(){
      location.href = "#{User.new.recordings_path()}";
    }
  JS

  # Front-end JS event handler for the action 'songs' (index)
  #
  js_method :on_songs, <<-JS
    function(){
      location.href = "#{User.new.songs_path()}";
    }
  JS

  # Front-end JS event handler for the action 'tags' (index)
  #
  js_method :on_tags, <<-JS
    function(){
      location.href = "#{User.new.tags_path()}";
    }
  JS

  # Front-end JS event handler for the action 'users' (index)
  #
  js_method :on_users, <<-JS
    function(){
      location.href = "#{User.new.users_path()}";
    }
  JS

  # Front-end JS event handler for the action 'users' (index)
  #
  js_method :on_app_parameters, <<-JS
    function(){
      location.href = "#{User.new.app_parameters_path()}";
    }
  JS
  # ---------------------------------------------------------------------------

  # Front-end JS event handler for the action 'index' (welcome)
  #
  js_method :on_index, <<-JS
    function(){
      location.href = "#{User.new.index_path()}";
    }
  JS

  # Front-end JS event handler for the action 'about' (welcome)
  #
  js_method :on_about, <<-JS
    function(){
      location.href = "#{User.new.about_path()}";
    }
  JS

  # Front-end JS event handler for the action 'contact_us' (welcome)
  #
  js_method :on_contact_us, <<-JS
    function(){
      location.href = "#{User.new.contact_us_path()}";
    }
  JS

  # Front-end JS event handler for the action 'whos_online' (welcome)
  #
  js_method :on_whos_online, <<-JS
    function(){
      location.href = "#{User.new.whos_online_path()}";
    }
  JS
  # ---------------------------------------------------------------------------

  # Front-end JS event handler for the action 'edit_current_user' (welcome)
  #
  js_method :on_edit_current_user, <<-JS
    function(){
      location.href = "#{User.new.edit_current_user_path()}";
    }
  JS

  # Front-end JS event handler for the action 'upload' (upload)
  #
  js_method :on_upload, <<-JS
    function(){
      location.href = "#{User.new.upload_path()}";
    }
  JS

  # Front-end JS event handler for the action 'manage_files' (upload)
  #
  js_method :on_manage_files, <<-JS
    function(){
      location.href = "#{User.new.manage_files_path()}";
    }
  JS
  # ---------------------------------------------------------------------------

  # Front-end JS event handler for the action 'logout' (login)
  #
  js_method :on_logout, <<-JS
    function(){
      location.href = "#{User.new.logout_path()}";
    }
  JS
  # ---------------------------------------------------------------------------
end
