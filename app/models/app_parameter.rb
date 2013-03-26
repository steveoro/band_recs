=begin
  
= AppParameter

  - version:  3.00.15.20120220 - customized for "band_recs"
  - author:   Steve A.

  Common app_parameter base model for the Agex5 framework.
  This contains only standardized features among all applications. For customizations,
  check out the lib/framework/NamingTools module.

=end
require 'framework/naming_tools'


class AppParameter < ActiveRecord::Base
  validates_length_of :controller_name, :maximum => 255, :allow_nil => true
  validates_length_of :action_name, :maximum => 255, :allow_nil => true

  validates_length_of :a_string, :maximum => 255, :allow_nil => true

  validates_numericality_of :a_integer, :allow_nil => true, :only_integer => true, :message => I18n.t('is not a valid integer number')
  validates_numericality_of :a_decimal, :allow_nil => true, :message => I18n.t('is not a valid number')
  validates_numericality_of :range_x, :allow_nil => true, :only_integer => true, :message => I18n.t('is not a valid integer number')
  validates_numericality_of :range_y, :allow_nil => true, :only_integer => true, :message => I18n.t('is not a valid integer number')

  validates_length_of :a_name, :maximum => 255, :allow_nil => true
  validates_length_of :a_filename, :maximum => 255, :allow_nil => true

  validates_numericality_of :code_type_1, :allow_nil => true, :only_integer => true, :message => I18n.t('is not a valid integer number')
  validates_numericality_of :code_type_2, :allow_nil => true, :only_integer => true, :message => I18n.t('is not a valid integer number')
  validates_numericality_of :code_type_3, :allow_nil => true, :only_integer => true, :message => I18n.t('is not a valid integer number')
  validates_numericality_of :code_type_4, :allow_nil => true, :only_integer => true, :message => I18n.t('is not a valid integer number')

                                # Param ID codes:
                                #################
  PARAM_VERSIONING_CODE             = 1
  PARAM_APP_NAME_FIELD              = 'a_name'
  PARAM_DB_VERSION_FIELD            = 'a_string'
                                                    # For the following fields, when not null their value will be used as default for the corresponding columns which they represent:
  DEFAULT_FIRM_ID_FIELD             = 'a_integer'   # Column used for default user firm_id (any controller)
  CURRENCY_ID_OVERRIDE_FIELD        = 'code_type_1' # Column used for currency_id override (any controller)
  # ----------------------------------------------------------------------------

  # The Controller parameter rows will start with this code + step * index_of( position inside NamingTools::PARAM_CTRL_SYMS[] )
  PARAM_CTRL_START                  = 5000
  # Difference in step in between each parameter row code for the Controllers
  PARAM_CTRL_CODE_STEP              = 1000

  PAGINATION_ENABLE_FIELD           = 'a_bool'      # true (1) to enable pagination
  PAGINATION_ROWS_FIELD             = 'range_y'     # Number of rows for each management page (depends also upon filtering, below)

  FILTERING_RADIUS_FIELD            = 'range_x'     # 'Radius' of filtering days, usually starting backwards from today (current date)
  FILTERING_STRFTIME_FIELD          = 'free_text_1' # strftime() formatting text to allow fine-grained resolution or approx. of date-time strings
  # ----------------------------------------------------------------------------

  # The main "access level" parameter rows will start at this code (included)
  PARAM_ACCESS_LEVEL_START          = 100

  # The main "access level" parameter rows will end at this code (included)
  PARAM_ACCESS_LEVEL_END            = 109

  ACCESS_LEVEL_FIELD                = 'a_integer'   # Level required for access (usually 0..9)
  CTRL_LIST_FIELD                   = 'free_text_1' # Comma-separated list of controller names that have CRUD access at this level

  # The main "black-list" parameter rows will start at this code (included).
  #
  # These are for controller/action pairs that require special permission levels
  # beyond the ones set with the main "controller access level" parameter.
  #
  # For each "special" (controller, action) pair a new row should be inserted, giving to the
  # columns CTRL_NAME_FIELD and ACTION_NAME_FIELD their proper value.
  # ACCESS_LEVEL_FIELD will store the level required for full access to the action,
  # regardless is either a GET or POST.
  #
  PARAM_BLACKLIST_ACCESS_START      = 1000

  # The main "black-list" parameter rows will end at this code (included). (See note above)
  PARAM_BLACKLIST_ACCESS_END        = 1999

  CTRL_NAME_FIELD                   = 'controller_name'
  ACTION_NAME_FIELD                 = 'action_name'
  # ----------------------------------------------------------------------------

  # Retrieves the total pagination rows parameter value, assuming current parameter row instance uses the dedicated column for that.
  # In case no valid value is found, a default is returned.
  #
  def get_pagination_rows()
    result = self.send( PAGINATION_ROWS_FIELD )
    result.blank? ? 10 : result
  end

  # Retrieves the filtering radius (in days) value, assuming current parameter row instance uses the dedicated column for that.
  # In case no valid value is found, a default is returned.
  #
  def get_filtering_radius()
    result = self.send( FILTERING_RADIUS_FIELD )
    result.blank? ? 7 : result
  end

  # Retrieves the filtering resolution value, in the form of a +strftime+() format string, to allow
  # fine-grained approximation for each date-time value that has to be sorted as a text.
  #
  def get_filtering_resolution()
    result = self.send( FILTERING_STRFTIME_FIELD )
    result.blank? ? '%Y-%m-%d' : result
  end
  # ----------------------------------------------------------------------------


  # Retrieves a parameter row by its id, assuming it's required (thus throwing
  # an exception if not found).
  #
  def self.get_required_parameter( id, parameter_name )
    record = self.find_by_code( id )
    raise "AppParameter: missing required '#{parameter_name}' parameter row!" if record.nil?
    record
  end

  # Retrieves a string parameter given the Parameter code ID.
  # If no corresponding parameter rows are found, an empty string is returned.
  # id : the Parameter code id.
  def self.get_string_parameter( id )
    ap = self.find_by_code( id )
    ap.nil? ? '' : ap.a_string
  end

  # Retrieves an integer parameter given the Parameter code ID.
  # If no corresponding parameter rows are found, a 0 is returned.
  # id : the Parameter code id.
  def self.get_integer_parameter( id )
    ap = self.find_by_code( id )
    ap.nil? ? 0 : ap.a_integer
  end
  # ----------------------------------------------------------------------------

  # Retrieves the whole "versioning parameter" row.
  #
  def self.get_versioning_parameter()
    get_required_parameter( PARAM_VERSIONING_CODE, 'versioning' )
  end


  # Retrieves the dedicated parameter row for the specified controller name.
  #
  # == Parameters:
  # - +ctrl_sym+: name of the controller as symbol
  #
  def self.get_parameter_row_for( ctrl_sym )
    idx = NamingTools::PARAM_CTRL_SYMS.index( ctrl_sym.to_sym )
    code = AppParameter::PARAM_CTRL_START + idx * AppParameter::PARAM_CTRL_CODE_STEP
    ap = AppParameter.find_by_code( code )
    ap = AppParameter.find_by_code( PARAM_VERSIONING_CODE ) if ( ap.nil? )
    return ap
  end


  # Retrieves default pagination for the specified controller.
  # Will return a default value of 10 if the expected PAGINATION_ROWS_FIELD column is not set
  #
  # == Parameters:
  # - +ctrl_sym+: name of the controller as symbol
  #
  def self.get_default_pagination_rows_for( ctrl_sym )
    ap = self.get_parameter_row_for( ctrl_sym )
    raise "AppParameter.get_default_pagination_rows_for(#{ctrl_sym}): parameter row not found!" if ap.nil?
    return( ap.send( PAGINATION_ROWS_FIELD ) || 10 )
  end
  # ---------------------------------------------------------------------------
end
