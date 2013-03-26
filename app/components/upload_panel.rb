#
# Simple Upload form
#
# - author: Steve A.
# - vers. : 0.18.20120518
#
class UploadPanel < Netzke::Basepack::FormPanel

  js_property :body_padding, 5

  js_property :title, I18n.t(:upload_title, :scope => [:agex_action])

  # We do not need the default apply action (no model associated), so we define a custom action:
  action :perform_upload, :text => 'OK', :tooltip => I18n.t(:upload_tooltip, :scope => [:agex_action]), :icon => :tick

  js_property :bbar, [ :perform_upload.action ]


  # Override default configuration for bottom bar
  # (this level of override is required only if base class is a FormPanel, otherwise the js_property suffices enough)
  def configure_bbar( config )
    config[:bbar] = [ :perform_upload.action ]
  end


  # def self.js_extend_properties
    # {
      # :file_upload => true
    # }
  # end 


  items [
    {
      :xtype => :fieldcontainer, :layout => :vbox, :label_width => 125,
      :height => 95, :width => 600,
      :file_upload => true,

      :field_defaults => {
        :anchor => "100%", :margin => '4 2 2 2',
        :height => 18, :allow_blank => false
      },
      :items => [
        { :xtype => :textfield, :name => :upload_file_name, :field_label => I18n.t(:file_name),
          :empty_text => "(#{I18n.t(:file_name)})", :width => 400
        },
        { :xtype => :fileuploadfield, :name => :upload_file_path, :getter => lambda {|r| ""},
          :display_only => true, :field_label => I18n.t(:file_path), :empty_text => "(#{I18n.t(:file_path)})",
          :width => 550
        },
        { :xtype => :checkboxfield, :name => :keep_offline, :field_label => I18n.t(:keep_offline),
          :default_value => false, :width => 50
        }
      ]
    }
  ]

  # ---------------------------------------------------------------------------


  js_method :init_component, <<-JS
    function(){
      #{js_full_class_name}.superclass.initComponent.call(this);

      Ext.FocusManager.enable();
      var nav = Ext.create('Ext.util.KeyNav', Ext.getBody(), {
          "enter" : function(){
              this.onPerformUpload();
          },
          "up" : function() {
              var el = Ext.FocusManager.focusedCmp;
              if (el.up()) el.up().focus();
          },
          "down" : function() {
              var el = Ext.FocusManager.focusedCmp;
              if (el.items) el.items.items[0].focus();
          },
          scope : this
      });
    }  
  JS

  # ---------------------------------------------------------------------------


  js_method :on_perform_upload, <<-JS
    function() {
      var flds = this.getForm().getFields().items;
      var fn = flds[0].getValue();
      var fp = flds[1].getValue();
      this.performUpload( {filename:fn, originalfile:fp} );
    }
  JS


  js_method :successful_upload, <<-JS
    function( filename ) {
      Ext.Msg.show({
          title: "#{I18n.t(:upload, :scope => [:agex_action])}",
          msg: "'" + filename + "' #{I18n.t(:uploaded)}!",
          minWidth: 200,
          modal: true,
          icon: Ext.Msg.INFO,
          buttons: Ext.Msg.OK
       });
    }
  JS


  # Called by pressing the OK button
  endpoint :perform_upload do |params|
    logger.debug "\r\n!! ------ in :perform_upload (endpoint) -----"
    logger.debug params[:filename]
    logger.debug params[:originalfile]
    is_successful = true

    if params[:originalfile]
      data = ActiveSupport::JSON.decode( params[:data] )
      data.merge!( {:file => params[:originalfile].original_filename} )
      encodedData = ActiveSupport::JSON.encode(data)
      params.merge!( {:data => encodedData} )

      name =  params[:originalfile].original_filename
      directory = "public/uploads"
      path = File.join(directory, name)
      File.open(path, "wb") { |f|
        f.write( params[:originalfile].read )
      }
    else
      is_successful = false
    end

    # TODO do file upload
#    uploader = AudiofileUploader.new # '/home/steve/Projects_AptanaS3/band_recs.docs/' + 
#    uploader.cache!( File.open(params[:uploaded_file]) )


    if is_successful
      # flash msg:
      flash :notice => "#{I18n.t(:file)} '#{params[:filename]}' #{I18n.t(:uploaded)}!"
      { :netzke_feedback => @flash, :successful_upload => params[:filename] }                   # return result is required for success
    else
      # flash errors
      err_msg = I18n.t(:invalid_user)
      flash :error => err_msg
      # Checkout Netzke::Basepack::FormPanel::Services for more details:
      { :netzke_feedback => @flash, :apply_form_errors => {:user => [err_msg]} }
    end
  end

end