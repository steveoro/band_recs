#
# Team(s) management composite panel implementation
#
# - author: Steve A.
# - vers. : 0.25.20130315
#
class TakesWithTagsPanel < Netzke::Basepack::BorderLayoutPanel

  js_properties(  
    :prevent_header => true,
    :border => true
  )

  js_property :sorted_ids
  js_property :sorted_tags
  js_property :button_tag_array

  # Internal commodity references:
  js_property :cmp_this_container
  js_property :cmp_takes_list
  # ---------------------------------------------------------------------------


  def configuration
    super.merge(
      :persistence => true,
      :items => [
        :takes_list.component(
          :region => :center
        ),
        :tag_button_list.component(
          :region => :east,
          :collapsible => true,
          :collapsed => true,
          :split => true
        )
      ]
    )
  end


  # Overriding initComponent
  js_method :init_component, <<-JS
    function() {
      #{js_full_class_name}.superclass.initComponent.call(this);
                                                    // Call endpoint to dynamically build-up a button for each defined tag
// DEBUG
//      console.log('Before retrieveTagsHash...');
      this.retrieveTagsHash();
      /* [Steve, 20120726] At this point, the following JS instance properties have
       * been defined and filled up properly:
       *
       *  - sortedIds (used only during configuration of the tag-buttons container)
       *  - sortedTags (used only during configuration of the tag-buttons container)
       *  - buttonTagArray (used only during configuration of the tag-buttons container)
       */
                                                    // Retrieve and store the component references:
      cmpThisContainer = this;
      cmpTakesList = this.getComponent('takes_list');
                                                    // == OnSelectionChange: ==
      cmpTakesList.getSelectionModel().on( 'selectionchange',
        function( selModel ) {
// DEBUG
//          console.log( 'Selected rows:' );
          var allSelectionTags = [];
                                                    // For each selected model data row:
          Ext.iterate( selModel.selected.items,
            function( record, index ) {
              /* [Steve, 20120726] ASSUMING get_tags() returns always a comma-separated list of string tags: */
              var currTags = record.data.get_tags.split(',');
// DEBUG
//              console.log( 'row[' + index + ']=' + record.index + ' has tags: ' + currTags );
                                                    // Scan currente tags and add them to allSelectionTags array only when not already present:
              Ext.iterate( currTags,
                function( tagText, index ) {
                  if ( allSelectionTags.indexOf( tagText ) < 0 )
                    allSelectionTags.push( tagText );
                },
                this
              );
            },
            this
          );
                                                    // Retrieve the button container:
          var cmpButtonContainer = this.getComponent('tag_button_list');
                                                    // For each defined tag button:
          Ext.iterate( cmpButtonContainer.items.items,
            function( btnComponent, index ) {
              if ( allSelectionTags.indexOf( btnComponent.text ) >= 0 ) {
                // Button.toggle( state, suppressEvent ):
                btnComponent.toggle( true, true );
              }
              else {
                btnComponent.toggle( false, true );
              }
            },
            this
          );
        },                                          // == END OnSelectionChange ==
        this
      );
    }
  JS
  # ---------------------------------------------------------------------------


  component :takes_list do
    {
      :class_name => "TakesList",
      :scope => { :recording_id => config[:recording_id] },
      :strong_default_attrs => {
        :recording_id => config[:recording_id],
        :user_id => Netzke::Core.current_user.id
      }
    }
  end


  component :tag_button_list do
    {
      :class_name => "Netzke::Basepack::Panel",
      :title => I18n.t(:tags, {:scope=>[:agex_action]}),
      :width => 200,
      :layout => 'column'
    }
  end
  # ---------------------------------------------------------------------------
  # ---------------------------------------------------------------------------


  endpoint :retrieve_tags_hash do |params|
    { :after_retrieve_tags_hash => Tag.get_tags_hash() }
  end
  # ---------------------------------------------------------------------------


  js_method :after_retrieve_tags_hash, <<-JS
    function( resultObj ) {
      if ( ! Ext.isEmpty(resultObj) ) {             // Any results to process?
        var ids  = Ext.Object.getKeys( resultObj );
        var tags = Ext.Object.getValues( resultObj );
        sortedIds = [];
        sortedTags = Ext.Object.getValues( resultObj );
        sortedTags.sort();
                                                    // Sort also the IDs:
        Ext.Array.each( sortedTags, function( sortedValue, index, arrItself ) {
          Ext.Object.each( resultObj, function(key, origValue, objItself) {
            if ( origValue == sortedValue ) {
              sortedIds[ index ] = key;
              return false;                         // Stop the iteration
            }
          });
        });
                                                    // Build-up button config:
        buttonTagArray = new Array();
        Ext.Array.each( sortedIds, function( value, index, arrItself ) {
          buttonTagArray[ index ] = Ext.create('Ext.Button', {
            name: "btn_tag_" + value,
            text: sortedTags[ index ],
            tag_id: value,
            scale: 'small',
            padding: 1,
            margin: 3,
            enableToggle: true,
            scope: this,
            handler: function( button ) {           // Compose the data array with just the IDs:
              var rowArray = new Array();
              cmpTakesList.getSelectionModel().selected.each(
                function( record ) {
                  rowArray.push( record.data.id );
                },
                this
              );
                                                    // If there is data, send a request:
              if ( rowArray.length > 0 ) {          // Prepare parameters:
                var paramObj = {
                    tag_id: button.tag_id,
                    pressed: button.pressed,
                    take_id_list: rowArray
                };
                                                    // Call the endpoint:
                cmpThisContainer.doTagClick( paramObj );
              }
              else {
                alert( "#{I18n.t(:warning_no_data_to_send)}" );
              }
            }  
          });
        });
                                                    // Add button widgets config dynamically:
        this.getComponent('tag_button_list').add( buttonTagArray );
        this.getComponent('tag_button_list').forceComponentLayout();
      }
    }  
  JS
  # ---------------------------------------------------------------------------


  # Back-end method called from the +on_tag_button_click+ JS method
  #
  # == Params:
  #  - tag_id : Tag id to be used for all the chosen Takes
  #  - pressed: true if the tag is supposed to be created; false otherwise
  #  - take_id_list: array of chosen Take IDs for which the tag has to be either
  #                  created or removed (according to button status)
  #
  endpoint :do_tag_click do |params|
#    logger.debug "\r\n!! ------ in :do_tag_click(#{params[:tag_id]}, #{params[:pressed]}, #{params[:take_id_list].inspect()}) -----"
    tag_id = params[:tag_id]
    must_be_created = params[:pressed]
    take_id_list = params[:take_id_list]

    if ( (tag_id.to_i > 0) && (take_id_list.kind_of?(Array)) )
      take_id_list.each { |take_id|
#        logger.debug "Processing take id: #{take_id}..."
        if ( must_be_created )
          if ( Tag4Take.where( :tag_id => tag_id, :take_id => take_id ).first.nil? )
#            logger.debug "Adding tag id:#{tag_id}."
            Tag4Take.create( :tag_id => tag_id, :take_id => take_id, :user_id => Netzke::Core.current_user.id )
#          else
#            logger.debug "Tag id:#{tag_id} already set."
          end
        else
#          logger.debug "Removing tag id:#{tag_id}."
          Tag4Take.where( :tag_id => tag_id, :take_id => take_id ).destroy_all
        end
      }
    else
      logger.warn('do_tag_click(): nothing to do, wrong parameters.')
    end
    { :after_do_tag_click => true }
  end
  # ---------------------------------------------------------------------------


  # Restores the current selection after refreshing the data set.
  #
  js_method :after_do_tag_click, <<-JS
    function( result ) {                            // Save the index of each selected Model data row
      var selectedIndexes = [];
      Ext.Array.each( cmpTakesList.getSelectionModel().getSelection(), function( recordRow, index, arrItself ) {
        selectedIndexes.push( recordRow.index );
      });
                                                    // Refresh take_list (this will clear the selection)
      cmpTakesList.getStore().load({
        scope: this,                                // Restore the previous selection list upon load completion:
        callback: function( records, operation, success ) {
// DEBUG
//          console.log( 'Selected indexes: ' + selectedIndexes );
          /* [Steve, 20120726] The array of record row instances must be re-built using the
           * selection's indexes because the array item (Model Row record) instances from
           * cmpTakesList.getSelectionModel().getSelection() cannot be referenced properly
           * inside the callback, and cloning the array changes the elements internal IDs...
           * (Assuming the dataset does not change, the indexes are "good enough".)
           */
          var selectedRows = [];
          Ext.Array.each( selectedIndexes, function( arrayItem, index, arrItself ) {
// DEBUG
//            console.log( 'Storing row #' + arrayItem );
            selectedRows.push( records[arrayItem] );
          });
          cmpTakesList.getSelectionModel().select( selectedRows );
        }
      });
    }  
  JS
  # ---------------------------------------------------------------------------
end
