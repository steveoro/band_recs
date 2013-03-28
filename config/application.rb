require File.expand_path('../boot', __FILE__)

require 'rails/all'

if defined?(Bundler)
  # If you precompile assets before deploying to production, use this line
  Bundler.require(*Rails.groups(:assets => %w(development test)))
  # If you want your assets lazily compiled in production, use this line
  # Bundler.require(:default, :assets, Rails.env)
end


# -- AgeX-specific stuff: --

# [Steve, 20080414] ** DO NOT CHANGE THE FOLLOWING UNLESS YOU KNOW WHAT YOU'RE DOING!! **
AGEX_FRAMEWORK_VERSION  = '3.03.03.20130328' unless defined? AGEX_FRAMEWORK_VERSION
AGEX_APP                = 'band_recs' unless defined? AGEX_APP
AGEX_APP_NAME           = 'BandRecs' unless defined? AGEX_APP_NAME
AGEX_APP_LOGO           = 'band_recs_logo.png' unless defined? AGEX_APP_LOGO

AGEX_FEATURES = {
#  (configure here additional features) 
} unless defined?(AGEX_FEATURES)


LOCALES = {'it' => 'it-IT', 'en' => 'en-US'}.freeze

# Set this to false to enable the self-destruct sequence on application timeout expiring.
DISABLE_SELF_DESTRUCT = true unless defined?(DISABLE_SELF_DESTRUCT)
# ---------------------------------------------------------------------------



module BandRecs
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
#    config.autoload_paths += %W(#{config.root}/app/reports)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer
    config.active_record.observers = :crud_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]

    # Enable the asset pipeline
    config.assets.enabled = true

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'
  end
end
