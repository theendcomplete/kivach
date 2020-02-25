Rails.application.configure do
  config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: %i[get post put patch delete options head]
    end
  end
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = false
  config.domain = '127.0.0.1:3000'
  config.action_controller.perform_caching = true
  config.action_mailer.perform_caching = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.active_record.verbose_query_logs = true
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
  config.primary_protocol = :http
  config.active_storage.service = :local
end
