#
# Specialized Take list/grid component implementation
#
# - author: Steve A.
# - vers. : 0.22.20120809
#
class TakesList < EntityGrid

  model 'Take'

  js_properties(
    :prevent_header => true,
    :header => false,
    :border => true,
    :popup_display_width => 450
  )
  # ---------------------------------------------------------------------------

  def configuration
    # ASSERT: assuming current_user is always set for this grid component:
    super.merge(
      :add_form_window_config => { :width => 500, :title => "#{I18n.t(:add)} #{I18n.t(:take, {:scope=>[:activerecord, :models]})}" },
      :edit_form_window_config => { :width => 500, :title => "#{I18n.t(:edit)} #{I18n.t(:take, {:scope=>[:activerecord, :models]})}" },

      :persistence => true,
      :columns => [
          { :name => :song__get_full_name, :label => I18n.t(:song, {:scope=>[:activerecord, :models]}),
            :scope => :netzke_sort_song_by_full_name_asc,
            :width => 250, :sorting_scope => :netzke_sort_take_by_song
          },
          { :name => :ordinal,    :label => I18n.t(:ordinal),   :width => 40 },
          { :name => :vote,       :label => I18n.t(:vote),      :width => 40 },
          { :name => :file_name,  :label => I18n.t(:file_name), :width => 220 },
          { :name => :get_tags,   :label => I18n.t(:tags, {:scope=>[:agex_action]}),
            :width => 220 },
          { :name => :notes,      :label => I18n.t(:notes),     :flex => 1 }
      ]
    )
  end
  # ---------------------------------------------------------------------------

end
