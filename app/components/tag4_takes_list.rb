#
# Specialized Tag4Takes list/grid component implementation
#
# - author: Steve A.
# - vers. : 0.22.20120809
#
class Tag4TakesList < MacroEntityGrid

  model 'Tag4Take'

  js_property( :target_for_ctrl_manage, Netzke::Core.controller.manage_recording_path(:locale => I18n.locale, :id => -1) )
  js_property( :target_id_field_for_ctrl_manage, 'take__recording_id' )


  # Override Top Toolbar from MacroEntityGrid to remove Add action, which is better carried out by the two recording manage/display panels)
  #
  js_property :tbar, [
     :show_details.action,
     :ctrl_manage.action,
     :search.action,
     "-",                                           # Adds a separator
     :edit.action, :del.action,
     :apply.action,
     "-",
     :edit_in_form.action,
     "-",
     :row_counter.action
  ]

  edit_form_window_config :width => 500, :title => "#{I18n.t(:edit_take_to_tag_link)}"
  # ---------------------------------------------------------------------------


  def configuration
    # ASSERT: assuming current_user is always set for this grid component:
    super.merge(
      :columns => [
          { :name => :take__recording_id, :hidden => true, :read_only => true, :enabled => false },
          { :name => :take__get_full_name, :label => I18n.t(:associated_take),
            :scope => :netzke_sort_take_by_rec_code_asc,
            :sorting_scope => :netzke_sort_tag4_take_by_take_full_name, :flex => 1
          }
      ]
    )
  end


  # Override default fields for forms. Must return an array understood by the
  # items property of the forms.
  #
  def default_fields_for_forms
    [
      { :name => :take__get_full_name, :field_label => I18n.t(:associated_take),
        :scope => :netzke_sort_take_by_rec_code_asc
      }
    ]
  end
  # ---------------------------------------------------------------------------
end
