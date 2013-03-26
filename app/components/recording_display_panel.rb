#
# Single recording(s) management composite panel implementation
#
# - author: Steve A.
# - vers. : 0.23.20120809
#
class RecordingDisplayPanel < Netzke::Basepack::BorderLayoutPanel


  js_properties(
    :prevent_header => true,
    :header => false,
    :border => true
  )

  js_property :s_file_name
  js_property :parsed_year
  js_property :parsed_month
  js_property :parsed_day
  js_property :parsed_sequence
  js_property :parsed_song_name

  js_property :id_band
  js_property :id_recording

  js_property :ids_song
  js_property :names_song
  # ---------------------------------------------------------------------------


  def configuration
    super.merge(
      :persistence => true,
      :items => [
        :take_name_entering_panel.component(
          :region => :north
        ),
        :recording_panel.component(
          :region => :center
        ),
        :takes_list_with_tags.component(
          :region => :south,
          :split => true
        )
      ]
    )
  end
  # ---------------------------------------------------------------------------


  component :take_name_entering_panel do
    {
      :class_name => "TakeNameParsePanel",
      :include_disbanded_groups => true,
      :hide_disbanded_checkbox => true
    }
  end


  component :recording_panel do
    # ASSERT: assuming current_user is always set for this grid component:
    {
      :class_name => "Netzke::Basepack::FormPanel",
      :model => 'Recording',
      :prevent_header => true,
      :record_id => config[:record_id],
      :strong_default_attrs => {
        :user_id => Netzke::Core.current_user.id
      },

      :items => [
        {
          :layout => :column, :border => false,
          :items => [
            {
              :column_width => 0.50, :border => false,
              :items => [
                { :name => :rec_code,     :width => 350,  :field_label => I18n.t(:rec_code) },
                { :name => :band__name,   :width => 350,  :field_label => I18n.t(:band, {:scope=>[:activerecord, :models]}),
                  :scope => :netzke_sort_band_by_name_asc
                }
              ]
            },
            {
              :column_width => 0.50, :border => false,
              :items => [
                { :name => :rec_date,     :width => 400,  :field_label => I18n.t(:rec_date) },
                { :name => :rec_order,    :width => 200,  :field_label => I18n.t(:rec_order) },
              ]
            }
          ]
        },

        {
          :layout => :column, :border => false, :column_width => 1.0,
          :items => [
            { :name => :description,  :field_label => I18n.t(:description), :width => 800 },
            { :name => :notes,        :field_label => I18n.t(:notes), :height => 80, :width => 800 }
          ]
        }
      ]
    }
  end


  component :takes_list_with_tags do
    {
      :class_name => "TakesWithTagsPanel",
      :height => 250,
      :recording_id => config[:record_id]
    }
  end
  # ---------------------------------------------------------------------------
  # ---------------------------------------------------------------------------


  # Overriding initComponent
  #
  js_method :init_component, <<-JS
    function() {
      #{js_full_class_name}.superclass.initComponent.call(this);
      var cmpParent   = this.getComponent('take_name_entering_panel');
      var cmpEditText = cmpParent.getComponent( "#{TakeNameParsePanel::FILE_NAME_FIELD_CMP_ID}" );

      cmpEditText.on(                               // Add listener on ENTER and TAB keypress:
        'keypress',
        function( textField, eventObj, eOpts ) {
          if ( eventObj.getKey() == Ext.EventObject.ENTER || eventObj.getKey() == Ext.EventObject.TAB ) {
            sFileName = textField.getValue();
                                                    // Retrieve the current band ID from the recording:
            var frmValues = Ext.ComponentMgr.get('recording_display_panel').getComponent('recording_panel').getForm().getValues();
            idRecording = frmValues['id'];
            parsedYear      = sFileName.substr(0, 4);
            parsedMonth     = sFileName.substr(4, 2);
            parsedDay       = sFileName.substr(6, 2);
            parsedSequence  = sFileName.substr(9, 2);
            parsedSongName  = sFileName.substr(12, sFileName.length - 16);
                                                    // Call endpoint to retrieve possible values for row insert:
            this.findPossibleDefaults({ song: parsedSongName });
          }
        },
        this
      );
    }
  JS
  # ---------------------------------------------------------------------------


  js_method :after_find_possible_defaults, <<-JS
    function( resultObj ) {
      if ( ! Ext.isEmpty(resultObj) ) {
        idsSong = Ext.Object.getKeys( resultObj );
        namesSong = Ext.Object.getValues( resultObj );
                                                    // Build-up Song items config:
        var songConfig = new Array();
        Ext.Array.each( idsSong, function( value, index, arrItself ) {
          songConfig[ index ] = {
            inputValue: value,
            name: 'song_id',
            boxLabel: namesSong[ index ],
            checked: ( index == 0 ? true : false )
          };
        });

        var frm = Ext.create('Ext.FormPanel', {
          frame: false,
          fieldDefaults: {
            labelWidth: 110
          },
          width: 400,
          bodyPadding: 10,
          items: [
            {
              xtype: 'radiogroup',
              fieldLabel: "#{I18n.t(:which_song)}",
              columns: 1,
              items: songConfig
            }
          ],
          buttons: [
            {
              text: "#{I18n.t(:ok, :scope=>[:netzke,:basepack,:grid_panel,:record_form_window,:actions])}",
              handler: function() {
                                                    // Prepare parameters:
                var paramObj = Ext.Object.merge(
                  frm.getForm().getValues(),
                  {
                    recording_id: idRecording,
                    y: parsedYear,
                    m: parsedMonth,
                    d: parsedDay,
                    seq: parsedSequence,
                    filename: sFileName
                  }
                );
                                                    // Call the endpoint:
                var thisParent = Ext.ComponentManager.get('recording_display_panel');
                thisParent.doAddRecordingAndTake( paramObj );
                frm.up('window').hide();
              }
            },
            {
              text: "#{I18n.t(:cancel, :scope=>[:netzke,:basepack,:grid_panel,:record_form_window,:actions])}",
              handler: function() {
                frm.getForm().reset();
                frm.up('window').hide();
              }
            }
          ]
        });

        Ext.widget('window', {
          title: "#{I18n.t(:insert_new_recording_take)}",
          layout: 'fit',
          modal: true,
          items: frm
        }).show();
      }

    }
  JS
  # ---------------------------------------------------------------------------


  js_method :after_do_add_rows, <<-JS
    function( result ) {
      if ( result ) {
        Ext.ComponentManager.get( 'recording_display_panel__takes_list_with_tags__takes_list' ).getStore().load();
      }
    }  
  JS
  # ---------------------------------------------------------------------------
  # ---------------------------------------------------------------------------


  # Back-end method called from the +add_recording_take_data_rows+ JS method
  #
  # == Params:
  #  - song : the song name for the recording/take pair
  #
  # == Returns:
  #  - invokes <tt>afterFindPossibleDefaults( hash_result )</tt>, where +hash_result+ is an Hash
  #    having this structure:
  #
  #           { song_id1: song_name1, song_id2: song_name2, ... }
  #
  endpoint :find_possible_defaults do |params|
#    logger.debug "\r\n!! ------ in :find_possible_defaults(#{params[:song]}) -----"

    song_name = params[:song]
    song_hash = {}
    if song_name
      tokens = song_name.split(/_| |-/)
      word1 = tokens[0]
      word2 = tokens[1] ? tokens[1] : ''
      key_word = ( word1.size >= word2.size ? word1 : word2 )
      songs_found = Song.find( :all, :conditions => "name LIKE '%#{key_word}%'" )
      songs_found.each{ |row| song_hash[row.id] = row.name }
    end

    { :after_find_possible_defaults => song_hash }
  end
  # ---------------------------------------------------------------------------



  # Back-end method called to add new rows for both Recording and Take models.
  #
  # If a Recording row for the specified band_id already exists with an identical
  # recording code (based upon the date of the take), no Recording row will be added.
  #
  # == Params:
  #  - recording_id: : the current recording id
  #  - song_id : the chosen song id
  #  - y/m/d: year, month and day of the recording take
  #  - seq: the sequential ordering for the recording take
  #  - filename: the associated filename of the take
  #
  endpoint :do_add_recording_and_take do |params|
    logger.debug "\r\n!! ------ in :do_add_recording_and_take (endpoint) -----"

# FIXME really needed?
    # Set locale override since Netzke controller doesn't recognize it (yet):
#    I18n.locale = params[:locale].to_sym if params[:locale]
    recording_id = params[:recording_id].to_i
    song_id = params[:song_id].to_i
    year = params[:y].to_i
    month = params[:m].to_i
    day = params[:d].to_i
    take_number = params[:seq].to_i
    filename = params[:filename]
    logger.debug "Recording ID #{recording_id}, song ID #{song_id} @ #{year}-#{month}-#{day}, n.#{take_number}"
                                                    # To check that the parameter is valid:
    rec = Recording.find_by_id( recording_id )
    user_name = Netzke::Core.current_user.name
    is_ok = false

    if ( rec.nil? )                                 # No rows were found? Add new Recording row:
      logger.error( "[E]-Unable to find Recording row with id #{recording_id}!" )
    end

    if rec.id                                       # Add new Take row:
      t = Take.new(
          :recording_id => recording_id, :song_id => song_id,
          :ordinal => take_number, :file_name => filename,
          :user_id => Netzke::Core.current_user.id
      )
      if t.save!()
        logger.info( "New Take row added successfully by user '#{user_name}'." )
        is_ok = true
      end
    end

#    logger.debug "---------------------------------"
    { :after_do_add_rows => is_ok }
  end
  # ---------------------------------------------------------------------------

end
