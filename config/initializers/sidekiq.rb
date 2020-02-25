Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost:6379' }

  # config.death_handlers << ->(job, error) do
  #   payload = {
  #     message: error[:message],
  #     backtrace: error[:backtrace]&.join("\n"),
  #     extra: job
  #   }
  #   ServerError.create!(payload)
  # end

  config.error_handlers << lambda { |error, ctx_hash|
    payload = {
      message: error.message,
      backtrace: error.backtrace.join("\n"),
      extra: ctx_hash
    }
    ServerError.where(message: error.message, backtrace: error.backtrace.join("\n")).first_or_create!(payload)
  }
end

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost:6379' }
end
