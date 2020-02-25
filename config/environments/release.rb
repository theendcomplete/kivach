Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins 'admin.kivach.release.trinitydigital.ru', 'localhost:4211', '127.0.0.1:4211'
      resource '*', headers: :any, methods: %i[get post put patch delete options head]
    end
  end

  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.active_storage.service = :yandex
  config.primary_protocol = :https
  config.log_level = :debug
  config.log_tags = [:request_id]
  config.domain = 'api.kivach.release.trinitydigital.ru'
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  if ENV['RAILS_LOG_TO_STDOUT'].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end
  config.active_record.dump_schema_after_migration = false
end
