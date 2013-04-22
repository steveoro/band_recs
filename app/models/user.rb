# encoding: utf-8
require 'digest/sha1'
require 'common/format'

require 'framework/naming_tools'
require 'i18n'


class User < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  validates_presence_of   :name
  validates_uniqueness_of :name, :message => :already_exists

  validates_presence_of :hashed_pwd
  validates_length_of   :hashed_pwd, :within => 6..255

  validates_presence_of :salt
  validates_length_of   :salt, :within => 1..128

  validates_numericality_of :authorization_level, :with => /[0123456789]/, :message => :must_be_a_number_from_0_to_9

                                                    # Virtual attributes:
  validates_presence_of :password, :password_confirmation
  validates_length_of   :password, :within => 6..128

  attr_accessor :password_confirmation
  validates_confirmation_of :password

  belongs_to :user
  # [Steve, 20120212] Validating le_user fails always because of validation requirements inside User (password & salt)
#  validates_associated :user                       # (Do not enable this for User)
  validates_presence_of :user_id

  # [Steve, 20120212] Using "netzke_attribute" helper to define in the model the configuration
  # of each column/attribute makes localization of the label unusable, since the model class
  # receives the "netzke_attribute" configuration way before the current locale is actually defined.
  # So, it is way better to keep column configuration directly inside Netzke components or in the
  # view definitions using the netzke helper.


  #-----------------------------------------------------------------------------
  # Base methods:
  #-----------------------------------------------------------------------------
  #++


  # Utility method to retrieve the controller base route directly from an instance of the model
  def base_uri
    users_path( self )
  end

  # Computes a descriptive name associated with this data
  def get_full_name
    "#{self.name} (#{self.description})"
  end

  # to_s() override for debugging purposes:
  def to_s
    "[User: '#{get_full_name}']"
  end
  # ----------------------------------------------------------------------------


  # Checks if a specified +ctrl_name+ is included in the list of accessible controllers
  # for this user instance access level (defined in +authorization_level+).
  #
  def can_access( ctrl_name )
    rows = AppParameter.where( "code >= #{AppParameter::PARAM_ACCESS_LEVEL_START} and code <= #{AppParameter::PARAM_ACCESS_LEVEL_START + self.authorization_level}" )
                                                    # Collect all accessible controller names up to this user level:
    arr = rows.collect { |row| row.free_text_1 }
    arr.delete('')
    accessible_ctrl_names = arr.join(',').gsub(' ','').split(',').compact
    return accessible_ctrl_names.include?( ctrl_name.to_s )
  end


  # Checks if this User instance can perform the specified controller, action combination
  # according to its authorization level.
  #
  def can_perform( ctrl_name, action_name )
    row = AppParameter.where( "code >= #{AppParameter::PARAM_BLACKLIST_ACCESS_START} and code <= #{AppParameter::PARAM_BLACKLIST_ACCESS_END} and controller_name='#{ctrl_name}' and action_name='#{action_name}'" ).first
    if ( row )
# DEBUG
#      puts "=> [#{self.name}] can_perform( #{ctrl_name}, #{action_name} )? #{(self.authorization_level >= row.a_integer)}.\r\n"
      return ( self.authorization_level >= row.a_integer )
    else
# DEBUG
#      puts "=> [#{self.name}] can_perform( #{ctrl_name}, #{action_name} )? No restrictions found.\r\n"
      return true
    end
  end


  # Verifies that a specific user id can perform a specific action.
  # Returns false otherwise.
  #
  # Works exactly as User::can_do(), but for row instances, thus sparing a query to retrieve the data, in case the row as already been read.
  #
  # +action_name+ = the name of the action to be executed
  # +ctrl_name+ = the controller name.
  #
  # See module #AsUserRights.
  #
  def can_do( ctrl_name, action_name = 'index' )
# DEBUG
#    puts "\r\n=> [#{self.name}] can_do( #{ctrl_name}, #{action_name} )?"
    if can_access( ctrl_name.to_s )
# DEBUG
#      puts "-- can_access: ok. Checking performing restrictions..."
      return can_perform( ctrl_name.to_s, action_name.to_s )
    else                                            # Controller access refused!
# DEBUG
#      puts "-- access denied!"
      false
    end
  end


  # Verifies that a specific user id can perform a specific action.
  # Returns false otherwise.
  #
  # +id+ = the id of the User
  # +action_name+ = the name of the action to be executed
  # +ctrl_name+ = the controller name.
  #
  # See module AsUserRights#.
  #
  def User.can_do( id, ctrl_name, action_name = 'index' )
    if id && user = User.find_by_id( id )
      user && user.can_do( ctrl_name, action_name )
    else
      false
    end
  end
  # ----------------------------------------------------------------------------

  # Read accessor override for virtual attribute
  def password
    @password
  end

  # Write accessor override for virtual attribute
  def password=(pwd)
    @password = pwd
    create_new_salt
    self.hashed_pwd = User.encrypted_password( self.password, self.salt )
  end

  # Safe way to delete a user
  def safe_delete
    transaction do
      destroy
      if User.count.zero?
        raise t("The deletion of the last user is not allowed.")
      end
    end
  end
  # ----------------------------------------------------------------------------


  protected


  def validate
    errors.add_to_base( t(:password_missing) ) if hashed_pwd.blank?
  end


  def self.authenticate(user_name, user_password)
    user = self.find_by_name(user_name)
    if user
      user_password = '' if user_password.nil?      # Avoid nil parameters
      expected_pwd = encrypted_password( user_password, user.salt )
      if user.hashed_pwd != expected_pwd
        user = nil
      end
    end
    user
  end
  # ----------------------------------------------------------------------------


  private


  def self.encrypted_password( user_password, salt )
    string_to_hash = "#{user_password}ASDàVf]€sdò%fsE:WQtr3S.Wdfgsd5(FyhNSDFr#{salt}"
    Digest::SHA1.hexdigest( string_to_hash )
  end


  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  # ----------------------------------------------------------------------------
end
