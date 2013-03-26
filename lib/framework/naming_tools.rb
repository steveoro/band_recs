require 'singleton'

#
# == NamingTools: Framework-specific naming convention tool class.
#
# A singleton utility class used to check and manage the framework naming conventions and the default access grant separation levels.
#
# (p) 2008-2012, FASAR Software, Italy
#
class NamingTools
  include Singleton


  public


  # List of all controller names that have a dedicated parameter row inside table app_parameters
  #
  PARAM_CTRL_SYMS = [
    :authors, :bands, :musicians, :recordings, :songs, :tags, :takes,
    :users, :welcome
  ]

  # Hash for all custom app_parameters column names used to store default values for each
  # controller of the application. Not all controller names need to be enlisted (nor they need
  # to have custom default values stored inside app_parameters).
  #
  DEFAULT_VALUES_IN_APP_PARAMETERS = {
    # :invoices => {
      # :soc_security => 'a_decimal',
      # :account_wage => 'a_decimal_2',
      # :vat_tax      => 'a_decimal_3',
      # :discount     => 'a_decimal_4'
    # }
  }
  # ---------------------------------------------------------------------------


  # Returns the <tt>app_parameters</tt>  column name (as string) used to store the default value for the couple
  # <tt>( controller_sym, field_sym )</tt> specified as symbols. Returns +nil+ if none was found.
  #
  def self.get_field_name_for_default_value_in_app_parameters_for( controller_sym, field_sym )
    field_hash = NamingTools::DEFAULT_VALUES_IN_APP_PARAMETERS[ controller_sym ]
    return field_hash[ field_sym ] unless field_hash.nil?
    nil
  end
  # ---------------------------------------------------------------------------
end