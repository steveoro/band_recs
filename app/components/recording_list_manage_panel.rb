#
# Recording(s) List management composite panel implementation
#
# - author: Steve A.
# - vers. : 0.23.20120809
#
class RecordingListManagePanel < Netzke::Basepack::BorderLayoutPanel


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

  js_property :ids_band
  js_property :ids_song
  js_property :names_band
  js_property :names_song
  # ---------------------------------------------------------------------------


  def configuration
    super.merge(
      :persistence => true,
      :items => [
        :take_name_entering_panel.component(
          :region => :north
        ),
        :recordings_list.component(
          :region => :center
        ),
        :takes_list_with_tags.component(
          :region => :south,
          :disabled => true,    # [Steve, 20120517] Having the slave component disabled as default, fixes the issue that arises from adding slave rows while there's no master row selected...
          :split => true
        )
      ]
    )
  end
  # ---------------------------------------------------------------------------


  component :take_name_entering_panel do
    {
      :class_name => "TakeNameParsePanel",
      :include_disbanded_groups => false
    }
  end


  component :recordings_list do
    # ASSERT: assuming current_user is always set for this grid component:
    {
      :class_name => "EntityGrid",
      :model => 'Recording',
      :prevent_header => true,

      :add_form_window_config => { :width => 500, :title => "#{I18n.t(:add)} #{I18n.t(:recording, {:scope=>[:activerecord, :models]})}" },
      :edit_form_window_config => { :width => 500, :title => "#{I18n.t(:edit)} #{I18n.t(:recording, {:scope=>[:activerecord, :models]})}" },
      :strong_default_attrs => {
        :user_id => Netzke::Core.current_user.id
      },

      :columns => [
          { :name => :rec_code,     :label => I18n.t(:rec_code),    :width => 150, :summary_type => :count },
          { :name => :band__name,   :label => I18n.t(:band, {:scope=>[:activerecord, :models]}),
            :scope => :netzke_sort_band_by_name_asc,
            :width => 120,          :summary_type => :count,        :sorting_scope => :netzke_sort_recording_by_band
          },
          { :name => :rec_date,     :label => I18n.t(:rec_date),    :width => 85 },
          { :name => :rec_order,    :label => I18n.t(:rec_order),   :width => 40 },
          { :name => :description,  :label => I18n.t(:description), :width => 200 },
          { :name => :notes,        :label => I18n.t(:notes),       :flex => 1 }
      ]
    }
  end


  component :takes_list_with_tags do
    {
      :class_name => "TakesWithTagsPanel",
      :height => 250,
      :recording_id => component_session[:selected_recording_id]
    }
  end
  # ---------------------------------------------------------------------------
  # ---------------------------------------------------------------------------


  # Overriding initComponent
  #
  js_method :init_component, <<-JS
    function() {
      #{js_full_class_name}.superclass.initComponent.call(this);

      // On each row selection change we update both the song list data:
      var cmpRecordingList = this.getComponent('recordings_list');
                                                    // == OnSelectionChange: ==
      cmpRecordingList.getSelectionModel().on( 'selectionchange',
        function( selModel ) {
          var hasSelection = selModel.hasSelection();
          if ( hasSelection ) {
            var record = selModel.selected.items[0];
            this.selectRecording( {recording_id: record.get('id')} );
          }
          var cmpParent = this.getComponent('takes_list_with_tags');
          cmpParent.setDisabled( !hasSelection );
          cmpParent.getComponent( 'takes_list' ).getStore().load();
        },
        this
      );

      var cmpParent   = this.getComponent('take_name_entering_panel');
      var cmpEditText = cmpParent.getComponent( "#{TakeNameParsePanel::FILE_NAME_FIELD_CMP_ID}" );
      var cmpIncludeChkBox = cmpParent.getComponent( "#{TakeNameParsePanel::INCLUDE_ALL_BANDS_CHKBOX_CMP_ID}" );

      cmpEditText.on(                               // Add listener on ENTER and TAB keypress:
        'keypress',
        function( textField, eventObj, eOpts ) {
          if ( eventObj.getKey() == Ext.EventObject.ENTER || eventObj.getKey() == Ext.EventObject.TAB ) {
            sFileName = textField.getValue();
            parsedYear      = sFileName.substr(0, 4);
            parsedMonth     = sFileName.substr(4, 2);
            parsedDay       = sFileName.substr(6, 2);
            parsedSequence  = sFileName.substr(9, 2);
            parsedSongName  = sFileName.substr(12, sFileName.length - 16);
                                                    // Call endpoint to retrieve possible values for row insert:
            this.findPossibleDefaults({ song: parsedSongName, include_all: cmpIncludeChkBox.getValue() });
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
        idsBand = Ext.Object.getKeys( resultObj[0] );
        idsSong = Ext.Object.getKeys( resultObj[1] );
        namesBand = Ext.Object.getValues( resultObj[0] );
        namesSong = Ext.Object.getValues( resultObj[1] );
                                                    // Build-up Band items config:
        var bandConfig = new Array();
        Ext.Array.each( idsBand, function( value, index, arrItself ) {
          bandConfig[ index ] = {
            inputValue: value,
            name: 'band_id',
            boxLabel: namesBand[ index ],
            checked: ( index == 0 ? true : false )
          };
        });
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
              fieldLabel: "#{I18n.t(:which_band)}",
              columns: 1,
              items: bandConfig
            },
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
                    y: parsedYear,
                    m: parsedMonth,
                    d: parsedDay,
                    seq: parsedSequence,
                    filename: sFileName
                  }
                );
                                                    // Call the endpoint:
                var thisParent = Ext.ComponentManager.get('recording_list_manage_panel');
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
    function( result_id ) {
      if ( result_id > 0 ) {
        var cmpRecordingList = Ext.ComponentManager.get( 'recording_list_manage_panel__recordings_list' );
                                                      // Refresh take_list (this will clear the selection)
        cmpRecordingList.getStore().load({
          scope: this,                                // Restore the previous selection list upon load completion:
          callback: function( records, operation, success ) {
            var foundRecordsIndex = -1;
                                                      // For each returned model data row, search for the result_id
            Ext.iterate( records,
              function( record, index ) {
// DEBUG
//                console.log( 'row[' + index + ']=' + record.index + ' has recording_id: ' + record.data.id );
                if ( record.data.id == result_id ) {
                  foundRecordsIndex = index;
                  return false; 
                }
              },
              this
            );
// DEBUG
//            console.log( 'Found row @ ' + foundRecordsIndex );
            if ( foundRecordsIndex >= 0 )           //  Changing selection will automatically update the sub-list:
              cmpRecordingList.getSelectionModel().select( foundRecordsIndex );
          }
        });
      }
    }  
  JS
  # ---------------------------------------------------------------------------
  # ---------------------------------------------------------------------------


  endpoint :select_recording do |params|
    # store selected recording id in the session for this component's instance
    component_session[:selected_recording_id] = params[:recording_id]
  end
  # ---------------------------------------------------------------------------


  # Back-end method called from the +add_recording_take_data_rows+ JS method
  #
  # == Params:
  #  - song : the song name for the recording/take pair
  #  - include_all: set this to true to include all music bands
  #
  # == Returns:
  #  - invokes <tt>afterFindPossibleDefaults( array_of_hash )</tt>, where +array_of_hash+ is an array
  #    having this structure (2 elements: #0 = list of possible bands, #1 = list of possible songs):
  #
  #         [
  #           { band_id1: band_name1, band_id2: band_name2, ... },
  #           { song_id1: song_name1, song_id2: song_name2, ... }
  #         ]
  #
  endpoint :find_possible_defaults do |params|
#    logger.debug "\r\n!! ------ in :find_possible_defaults(#{params[:song]}, #{params[:include_all]}) -----"
    include_all = params[:include_all]
    band_hash = {}
    bands_found = ( include_all ? Band.all() : Band.where( :disbanded_on => nil ) )
    bands_found.each{ |row| band_hash[row.id] = row.name }

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

    { :after_find_possible_defaults => [band_hash, song_hash] }
  end
  # ---------------------------------------------------------------------------



  # Back-end method called to add new rows for both Recording and Take models.
  #
  # If a Recording row for the specified band_id already exists with an identical
  # recording code (based upon the date of the take), no Recording row will be added.
  #
  # == Params:
  #  - band_id : the chosen band id
  #  - song_id : the chosen song id
  #  - y/m/d: year, month and day of the recording take
  #  - seq: the sequential ordering for the recording take
  #  - filename: the associated filename of the take
  #
  endpoint :do_add_recording_and_take do |params|
#    logger.debug "\r\n!! ------ in :do_add_recording_and_take (endpoint) -----"

# FIXME really needed?
    # Set locale override since Netzke controller doesn't recognize it (yet):
#    I18n.locale = params[:locale].to_sym if params[:locale]
    band_id = params[:band_id]
    song_id = params[:song_id]
    year = params[:y].to_i
    month = params[:m].to_i
    day = params[:d].to_i
    take_number = params[:seq].to_i
    filename = params[:filename]
#    logger.debug "band ID #{band_id}, song ID #{song_id} @ #{year}-#{month}-#{day}, n.#{take_number}"

    rec_rows = Recording.where( :rec_date => "#{year}-#{month}-#{day}" )
    rec = rec_rows.first
    user_name = Netzke::Core.current_user.name
    is_ok = false
    rec_id = -1

    if ( rec == nil )                               # No rows were found? Add new Recording row:
      rec = Recording.new(
          :band_id  => band_id,
          :rec_code => "#{sprintf("%4.4i",year)}#{sprintf("%2.2i",month)}#{sprintf("%2.2i",day)}",
          :rec_date => "#{year}-#{month}-#{day}",
          :description => '',
          :user_id => Netzke::Core.current_user.id
      )
      if rec.save!()
        logger.info( "New Recording row added successfully by user '#{user_name}'." )
        logger.debug "Saved Recording.id: #{rec.id}"
      end
    end

    if rec.id                                       # Add new Take row:
      rec_id = rec.id
      t = Take.new(
          :recording_id => rec_id, :song_id => song_id,
          :ordinal => take_number, :file_name => filename,
          :user_id => Netzke::Core.current_user.id
      )
      if t.save!()
        logger.info( "New Take row added successfully by user '#{user_name}'." )
        is_ok = true
      end
    end

#    logger.debug "---------------------------------"
    { :after_do_add_rows => rec_id }
  end
  # ---------------------------------------------------------------------------

end
