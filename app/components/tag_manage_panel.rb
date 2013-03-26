#
# Tag management composite panel implementation
#
# - author: Steve A.
# - vers. : 0.22.20120809
#
class TagManagePanel < Netzke::Basepack::BorderLayoutPanel

  js_properties(
    :prevent_header => true,
    :header => false,
    :border => true
  )


  def configuration
    super.merge(
      :persistence => true,
      :items => [
        :tags_list.component(
          :region => :west,
          :split => true
        ),
        :tag4_takes_list.component(
          :region => :center,
          :disabled => true,    # [Steve, 20120517] Having the slave component disabled as default, fixes the issue that arises from adding slave rows while there's no master row selected...
          :width => 700
        )
      ]
    )
  end


  # Overriding initComponent
  js_method :init_component, <<-JS
    function(){
      #{js_full_class_name}.superclass.initComponent.call(this);

      // On each row click we update the both the song list data:
      var listView = this.getComponent('tags_list').getView();
      listView.on( 'itemclick',
        function( listView, record ) {
          this.selectRecording( {tag_id: record.get('id')} );
          this.getComponent( 'tag4_takes_list' ).setDisabled( record.get('id') < 1 );
          this.getComponent( 'tag4_takes_list' ).getStore().load();
        },
        this
      );
    }
  JS
  # ---------------------------------------------------------------------------


  endpoint :select_recording do |params|
    # store selected tag id in the session for this component's instance
    component_session[:selected_tag_id] = params[:tag_id]
  end


  component :tags_list do
    # ASSERT: assuming current_user is always set for this grid component:
    {
      :class_name => "EntityGrid",
      :model => 'Tag',
      :prevent_header => true,
      :add_form_window_config => { :width => 400, :title => "#{I18n.t(:add)} #{I18n.t(:tag, {:scope=>[:activerecord, :models]})}" },
      :edit_form_window_config => { :width => 400, :title => "#{I18n.t(:edit)} #{I18n.t(:tag, {:scope=>[:activerecord, :models]})}" },
      :strong_default_attrs => {
        :user_id => Netzke::Core.current_user.id
      },

      :columns => [
          { :name => :name, :label => I18n.t(:name), :width => 250, :summary_type => :count }
      ]
    }
  end


  component :tag4_takes_list do
    {
      :class_name => "Tag4TakesList",
      :prevent_header => true,

      :scope => { :tag_id => component_session[:selected_tag_id] },
      :strong_default_attrs => {
        :tag_id  => component_session[:selected_tag_id],
        :user_id => Netzke::Core.current_user.id
      }
    }
  end
  # ---------------------------------------------------------------------------
end
