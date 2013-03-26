#
# Band management composite panel implementation
#
# - author: Steve A.
# - vers. : 0.36.20130315
#
class BandManagePanel < Netzke::Basepack::BorderLayoutPanel

  js_properties(
    :prevent_header => true,
    :header => false,
    :border => true
  )


  def configuration
    super.merge(
      :persistence => true,
      :items => [
        :bands_list.component(
          :region => :center
        ),
        :musicians_list.component(
          :region => :south,
          :height => 250,
          :disabled => true,    # [Steve, 20120517] Having the slave component disabled as default, fixes the issue that arises from adding slave rows while there's no master row selected...
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
      var listView = this.getComponent('bands_list').getView();
      listView.on( 'itemclick',
        function( listView, record ) {
          this.selectBand( {band_id: record.get('id')} );
          this.getComponent( 'musicians_list' ).setDisabled( record.get('id') < 1 );
          this.getComponent( 'musicians_list' ).getStore().load();
        },
        this
      );
    }
  JS
  # ---------------------------------------------------------------------------


  endpoint :select_band do |params|
    # store selected band id in the session for this component's instance
    component_session[:selected_band_id] = params[:band_id]
  end


  component :bands_list do
    # ASSERT: assuming current_user is always set for this grid component:
    {
      :class_name => "EntityGrid",
      :model => 'Band',
      :prevent_header => true,
      :add_form_window_config => { :width => 500, :title => "#{I18n.t(:add)} #{I18n.t(:band, {:scope=>[:activerecord, :models]})}" },
      :edit_form_window_config => { :width => 500, :title => "#{I18n.t(:edit)} #{I18n.t(:band, {:scope=>[:activerecord, :models]})}" },
      :strong_default_attrs => {
        :user_id => Netzke::Core.current_user.id
      },

      :columns => [
          { :name => :name,         :label => I18n.t(:name),   :width => 200, :summary_type => :count },
          { :name => :description,  :label => I18n.t(:description),   :flex => 1 },
          { :name => :notes,        :label => I18n.t(:notes),         :width => 200 },
          { :name => :founded_on,   :label => I18n.t(:founded_on),    :width => 85 },
          { :name => :disbanded_on, :label => I18n.t(:disbanded_on),  :width => 85 }
      ]
    }
  end


  component :musicians_list do
    {
      :class_name => "EntityGrid",
      :model => 'Musician4Band',
      :prevent_header => true,
      :scope => { :band_id => component_session[:selected_band_id] },
      :strong_default_attrs => {
        :band_id => component_session[:selected_band_id],
        :user_id => Netzke::Core.current_user.id
      },

      :add_form_window_config => { :width => 500, :title => "#{I18n.t(:add)} #{I18n.t(:musician, {:scope=>[:activerecord, :models]})}" },
      :edit_form_window_config => { :width => 500, :title => "#{I18n.t(:edit)} #{I18n.t(:musician, {:scope=>[:activerecord, :models]})}" },

      :columns => [
          { :name => :musician__get_full_name, :label => I18n.t(:musician, {:scope=>[:activerecord, :models]}),
            :width => 200, :summary_type => :count, 
            # [20121121] For the combo-boxes to have a working query after the 4th char is entered in the edit widget,
            # a lambda statement must be used. Using a pre-computed scope from the Model class prevents Netzke
            # (as of this version) to append the correct WHERE clause to the scope itself (with an inline lambda, instead, it works).
            :scope => lambda { |rel| rel.order("musicians.nickname, musicians.name") },
            :sorting_scope => :netzke_sort_musician4_band_by_full_name
          },
          { :name => :joined_on,  :label => I18n.t(:joined_on),  :width => 85 },
          { :name => :left_on,    :label => I18n.t(:left_on),    :width => 85 },
          { :name => :notes,      :label => I18n.t(:notes),      :flex => 1 }
      ]
    }
  end
  # ---------------------------------------------------------------------------
end
