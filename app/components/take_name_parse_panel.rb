#
# == Custom Panel component implementation
#
# - author: Steve A.
# - vers. : 0.19.20120727
#
# A custom Panel component used to add both Recording and Take rows just by entering a Recording Take
# file name that will be parsed to obtain the record values.
#
# If a Recording row already exists with the parsed code, only the Take row will be added.
#
# Programming logic is completely contained inside the parent component RecordingManagePanel.
#
class TakeNameParsePanel < Netzke::Basepack::Panel

  # Component Symbol used to uniquely address the "New Recording/Take file name" field
  FILE_NAME_FIELD_CMP_SYM  = :new_take_file_name

  # Component ID used to uniquely address the "New Recording/Take file name" field
  FILE_NAME_FIELD_CMP_ID   = FILE_NAME_FIELD_CMP_SYM.to_s

  # Component Symbol used to uniquely address the "Include all bands" checkbox field
  INCLUDE_ALL_BANDS_CHKBOX_CMP_SYM  = :include_all_bands_chkbox

  # Component ID used to uniquely address the "Include all bands" checkbox field
  INCLUDE_ALL_BANDS_CHKBOX_CMP_ID   = INCLUDE_ALL_BANDS_CHKBOX_CMP_SYM.to_s


  js_properties(
    :prevent_header => true,
    :header => false
  )


  def configuration
    super.merge(
      :frame => true,
      :min_width => 700,
      :min_height => 35,
      :height => 35,
      :margin => '1 1 1 1',
      :fieldDefaults => {
        :msgTarget => 'side',
        :autoFitErrors => false
      },
      :layout => 'hbox',
      :items => [
        {
          :xtype => 'textfield',
          :fieldLabel => "#{I18n.t(:add_new_recording_take_using_filename)}",
          :labelWidth => 270,
          :margin => '1 6 0 0',
          :id   => FILE_NAME_FIELD_CMP_ID,
          :name => FILE_NAME_FIELD_CMP_ID,
          :min_width => 250,
          :width => 500,
          :enable_key_events => true
        },
        {
          :xtype => :checkboxfield,
          :fieldLabel => "#{I18n.t(:include_also_disbanded_groups)}",
          :labelWidth => 230,
          :value => super[:include_disbanded_groups],
          :id   => INCLUDE_ALL_BANDS_CHKBOX_CMP_ID,
          :name => INCLUDE_ALL_BANDS_CHKBOX_CMP_ID,
          :min_width => 150,
          :width => 250,
          :margin => '1 2 0 6',
          :hidden => ( super[:hide_disbanded_checkbox].nil? ? false : super[:hide_disbanded_checkbox] )
        }
      ]
    )
  end


  js_method :init_component, <<-JS
    function(){
      #{js_full_class_name}.superclass.initComponent.call(this);
    }  
  JS
  # ---------------------------------------------------------------------------
end
