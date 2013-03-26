#
# Team(s) management composite panel implementation
#
# - author: Steve A.
# - vers. : 0.20.20120806
#
class AuthorManagePanel < Netzke::Basepack::BorderLayoutPanel

  js_properties(
    :prevent_header => true,
    :header => false,
    :border => true
  )


  def configuration
    super.merge(
      :persistence => true,
      :items => [
        :authors_list.component(
          :region => :center
        ),
        :songs_list.component(
          :region => :south,
          :disabled => true,    # [Steve, 20120517] Having the slave component disabled as default, fixes the issue that arises from adding slave rows while there's no master row selected...
          :height => 200,
          :split => true
        )
      ]
    )
  end


  # Overriding initComponent
  js_method :init_component, <<-JS
    function(){
      #{js_full_class_name}.superclass.initComponent.call(this);

      // On each row click we update the both the song list data:
      var listView = this.getComponent('authors_list').getView();
      listView.on( 'itemclick',
        function( listView, record ) {
          this.selectAuthor( {author_id: record.get('id')} );
          this.getComponent( 'songs_list' ).setDisabled( record.get('id') < 1 );
          this.getComponent( 'songs_list' ).getStore().load();
        },
        this
      );
    }
  JS
  # ---------------------------------------------------------------------------


  endpoint :select_author do |params|
    # store selected author id in the session for this component's instance
    component_session[:selected_author_id] = params[:author_id]
  end


  component :authors_list do
    # ASSERT: assuming current_user is always set for this grid component:
    {
      :class_name => "EntityGrid",
      :model => 'Author',
      :prevent_header => true,
      :add_form_window_config => { :width => 500, :title => "#{I18n.t(:add)} #{I18n.t(:author, {:scope=>[:activerecord, :models]})}" },
      :edit_form_window_config => { :width => 500, :title => "#{I18n.t(:edit)} #{I18n.t(:author, {:scope=>[:activerecord, :models]})}" },
      :strong_default_attrs => {
        :user_id => Netzke::Core.current_user.id
      },

      :columns => [
          { :name => :name, :label => I18n.t(:name), :flex => 1, :summary_type => :count }
      ]
    }
  end


  component :songs_list do
    {
      :class_name => "EntityGrid",
      :model => 'Song',
      :prevent_header => true,
      :scope => { :author_id => component_session[:selected_author_id] },
      :strong_default_attrs => {
        :author_id => component_session[:selected_author_id],
        :user_id => Netzke::Core.current_user.id
      },

      :add_form_window_config => { :width => 500, :title => "#{I18n.t(:add)} #{I18n.t(:song, {:scope=>[:activerecord, :models]})}" },
      :edit_form_window_config => { :width => 500, :title => "#{I18n.t(:edit)} #{I18n.t(:song, {:scope=>[:activerecord, :models]})}" },

      :columns => [
          { :name => :name, :label => I18n.t(:name), :flex => 1, :summary_type => :count }
      ]
    }
  end
  # ---------------------------------------------------------------------------
end
