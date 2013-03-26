#
# Specialized Take list/grid component implementation, used so far only inside SongManagePanel
#
# - author: Steve A.
# - vers. : 0.22.20120809
#
class TakesMacroEntityList < MacroEntityGrid

  model 'Take'

  js_properties(
    :prevent_header => true,
    :header => false,
    :border => true,
    :popup_display_width => 450
  )
  # ---------------------------------------------------------------------------

  js_property( :target_for_ctrl_manage, Netzke::Core.controller.manage_recording_path(:locale => I18n.locale, :id => -1) )
  js_property( :target_id_field_for_ctrl_manage, 'recording__id' )


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

  edit_form_window_config :width => 500, :title => "#{I18n.t(:edit)} #{I18n.t(:take, {:scope=>[:activerecord, :models]})}"
  # ---------------------------------------------------------------------------


  def configuration
    # ASSERT: assuming current_user is always set for this grid component:
    super.merge(
      :persistence => true,
      :columns => [
        # [Steve, 20120808] For :target_id_field_for_ctrl_manage to work, the "id" field chosen
        # for the ctrlManage action must come forcibly from a _meta.associationValues column.
        # For instance, see lines 96 and 125 of MacroEntityGrid.
        { :name => :recording__id, :hidden => true, :enabled => false },
        { :name => :recording__rec_code, :label => I18n.t(:recording, {:scope=>[:activerecord, :models]}),
          :scope => :netzke_sort_recording_by_rec_code_asc,
          :width => 180, :summary_type => :count, :sorting_scope => :netzke_sort_take_by_rec_code
        },
        { :name => :ordinal,    :label => I18n.t(:ordinal), :width => 40 },
        { :name => :vote,       :label => I18n.t(:vote),    :width => 40 },
        { :name => :file_name,  :label => I18n.t(:file_name), :width => 220 },
        { :name => :get_tags,   :label => I18n.t(:tags, {:scope=>[:agex_action]}),
          :width => 200 },
        { :name => :notes,      :label => I18n.t(:notes),   :flex => 1 }
      ]
    )
  end


  # Override default fields for forms. Must return an array understood by the
  # items property of the forms.
  #
  def default_fields_for_forms
    [
      { :name => :recording__rec_code, :field_label => I18n.t(:recording, {:scope=>[:activerecord, :models]}),
        :scope => :netzke_sort_recording_by_rec_code_asc,
        :width => 180, :sorting_scope => :netzke_sort_take_by_rec_code
      },
      { :name => :ordinal,    :field_label => I18n.t(:ordinal), :width => 40 },
      { :name => :vote,       :field_label => I18n.t(:vote),    :width => 40 },
      { :name => :file_name,  :field_label => I18n.t(:file_name), :width => 220 },
      { :name => :notes,      :field_label => I18n.t(:notes) }
    ]
  end
  # ---------------------------------------------------------------------------

end
