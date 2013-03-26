#
# Song management composite panel implementation
#
# - author: Steve A.
# - vers. : 0.36.20130315
#
class SongManagePanel < Netzke::Basepack::BorderLayoutPanel

  js_properties(
    :prevent_header => true,
    :header => false,
    :border => true
  )


  def configuration
    super.merge(
      :persistence => true,
      :items => [
        :songs_list.component(
          :region => :west,
          :split => true
        ),
        :takes_list.component(
          :region => :center,
          :disabled => true,    # [Steve, 20120517] Having the slave component disabled as default, fixes the issue that arises from adding slave rows while there's no master row selected...
          :width => 600
        )
      ]
    )
  end


  # Overriding initComponent
  js_method :init_component, <<-JS
    function(){
      #{js_full_class_name}.superclass.initComponent.call(this);

      // On each row click we update the both the song list data:
      var listView = this.getComponent('songs_list').getView();
      listView.on( 'itemclick',
        function( listView, record ) {
          this.selectSong( {song_id: record.get('id')} );
          this.getComponent( 'takes_list' ).setDisabled( record.get('id') < 1 );
          this.getComponent( 'takes_list' ).getStore().load();
        },
        this
      );
    }
  JS
  # ---------------------------------------------------------------------------


  endpoint :select_song do |params|
    # store selected song id in the session for this component's instance
    component_session[:selected_song_id] = params[:song_id]
  end


  component :songs_list do
    # ASSERT: assuming current_user is always set for this grid component:
    {
      :class_name => "EntityGrid",
      :model => 'Song',
      :prevent_header => true,
      :add_form_window_config => { :width => 500, :title => "#{I18n.t(:add)} #{I18n.t(:song, {:scope=>[:activerecord, :models]})}" },
      :edit_form_window_config => { :width => 500, :title => "#{I18n.t(:edit)} #{I18n.t(:song, {:scope=>[:activerecord, :models]})}" },
      :strong_default_attrs => {
        :user_id => Netzke::Core.current_user.id
      },

      :columns => [
          { :name => :name,         :label => I18n.t(:name),   :width => 200, :summary_type => :count },
          { :name => :author__name, :label => I18n.t(:author, {:scope=>[:activerecord, :models]}),
            # [20121121] For the combo-boxes to have a working query after the 4th char is entered in the edit widget,
            # a lambda statement must be used. Using a pre-computed scope from the Model class prevents Netzke
            # (as of this version) to append the correct WHERE clause to the scope itself (with an inline lambda, instead, it works).
            :scope => lambda { |rel| rel.order("authors.name") },
            :width => 160, :summary_type => :count, :sorting_scope => :netzke_sort_song_by_author
          }
      ]
    }
  end


  component :takes_list do
    {
      :class_name => "TakesMacroEntityList",
      :scope => { :song_id => component_session[:selected_song_id] },
      :strong_default_attrs => {
        :song_id => component_session[:selected_song_id],
        :user_id => Netzke::Core.current_user.id
      }
    }
  end
  # ---------------------------------------------------------------------------
end
