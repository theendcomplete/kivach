class Rack::Attack
  Rack::Attack.cache.store = ActiveSupport::Cache::MemoryStore.new

  safelist('allow-localhost') do |req|
    req.ip == '127.0.0.1' || req.ip == '::1'
  end

  throttle('requests per apikey+token', limit: 300, period: 30.seconds) do |req|
    id = [req.get_header('apikey'), req.get_header('token')].join
    id.presence || 'unknown'
  end

  # throttle('requests without apikey on private methods', limit: 1, period: 10.minutes) do |req|
  #  api_keys = Rails.application.secrets.api_keys
  #  if req.path ~ // && api_keys.present? && !api_keys.values.include?(request.headers[:apikey])
  #    req.ip
  #  end
  # end

  # Send the following response to throttled clients
  self.throttled_response = lambda { |env|
    retry_after = (env['rack.attack.match_data'] || {})[:period]
    [429,
     {
       'Content-Type' => 'application/json',
       'Retry-After' => retry_after.to_s
     },
     [
       { error_code: 'HTTP_REQUEST_REJECTED', error_text: 'Запросы поступают слишком часто, попробуйте позже' }.to_json
     ]]
  }

  self.blocklisted_response = lambda { |_env|
    [503, {}, ['Blocked']]
  }
end
