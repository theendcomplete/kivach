require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
# require 'action_cable/engine'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module KivachRecipesApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    config.api_only = true

    config.app = config_for :app
    config.i18n.fallbacks = true
    Time.zone = 'Europe/Moscow'
    config.time_zone = Time.zone
    config.encoding = "utf-8"

    config.exceptions_app = routes
    config.active_job.queue_adapter = :sidekiq
    config.cache_store = :redis_cache_store

    # Enable throttle control (https://github.com/kickstarter/rack-attack)
    config.middleware.use Rack::Attack
    config.filter_parameters << :password << :token
  end
end
