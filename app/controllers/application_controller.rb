class ApplicationController < ActionController::API
  # protect_from_forgery with: :exception

  helper_method :url_for_file

  rescue_from StandardError do |e|
    log_error e
    render_error Error::InternalServerError.new
  end

  rescue_from Error::CustomError do |e|
    render_error e
  end

  rescue_from ActiveRecord::ActiveRecordError do |e|
    render_activerecord_error e
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    render_activerecord_invalid e
  end

  rescue_from ActionController::ActionControllerError do |e|
    log_error e
    render_actioncontroller_error e
  end

  rescue_from ActionController::ParameterMissing do |e|
    render_actioncontroller_parametermissing e
  end

  def default_url_options(options = {})
    options.merge(protocol: Rails.application.config.primary_protocol)
  end

  def root
    @current_time = Time.current
    # @uptime = IO.read('/proc/uptime').split[0].to_f
    render 'root.json'
  end

  def handle_error_404
    raise Error::NotFound, code: 'ROUTE_NOT_FOUND'
  end

  def handle_error_500
    raise Error::InternalServerError, code: 'INTERNAL_SERVER_ERROR'
  end

  def schema
    head :not_found
  end

  def validate_apikey(key, key_id = nil)
    api_keys = Rails.application.secrets.api_keys
    api_keys.blank? || key_id.present? && api_keys[key_id] == key || key_id.blank? && api_keys.value?(key)
  end

  def authorize_apikey
    apikey = request.headers[:apikey]
    raise Error::Forbidden unless validate_apikey apikey
  end

  def respond(data, status = :ok)
    render json: data, status: status
  end

  def request_remote_ip
    request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip if request.present?
  end

  def url_for_file(file)
    url_for(file) if file.attached?
    # polymorphic_url(file, protocol: Rails.application.config.primary_protocol) if file.attached?
  end

  def render_activerecord_error(err)
    if err.is_a? ActiveRecord::StatementInvalid
      begin
        error = JSON.parse((err.to_s[/(ОШИБКА|ERROR):(.*)$/, 2] || '').strip, symbolize_names: true)
        if error[:code].blank?
          log_error err
          error[:code] = 'DATABASE_UNKNOWN_ERROR'
        end
        render_error Error::BadRequest.new(message: error[:text], code: error[:code], vars: error[:vars])
      rescue JSON::ParserError
        log_error err
        render_error Error::InternalServerError.new(code: 'DATABASE_CRITICAL_ERROR')
      end
    else
      log_error err
      render_error Error::BadRequest.new(code: err.class.to_s.upcase.sub(/:+/, '_'))
    end
  end

  def render_actioncontroller_error(err)
    code = err.class.to_s
    text = err.message if err.message != code
    render_error Error::BadRequest.new(message: text, code: code)
  end

  def render_activerecord_invalid(err)
    # err.record.errors.each {|key, err| p key, err }
    render_error Error::BadRequest.new(message: err.message, code: 'RECORD_INVALID')
  end

  def render_activecontroller_parametermissing(err)
    # err.record.errors.each {|key, err| p key, err }
    render_error Error::BadRequest.new(message: err.message, code: 'PARAMETER_MISSING')
  end

  def render_error(err)
    @error = err.render
    if @error.code.blank? && @error.message.blank?
      head @error.status
    else
      render 'error.json', status: @error.status
    end
  end

  def log_error(error, extra = nil)
    payload = {
      message: error.message,
      backtrace: error.backtrace.join("\n"),
      extra: extra
    }
    if request.present?
      payload.merge!(
        request_remote_ip: request_remote_ip,
        request_token: request.headers[:token],
        request_method: request.method,
        request_original_url: request.original_url,
        request_params: request.request_parameters
      )
    end
    ServerError.create!(payload)
  end

  def query_add_efilter_json(query, filter_json)
    filter = JSON.parse filter_json
    query.efilter(filter)
  rescue JSON::ParserError
    raise Error::BadRequest, code: 'PARAMS_EXTENDED_FILTER_INVALID'
  rescue Error::CustomError => e
    e.status = :bad_request
    raise e
  end

  def query_add_order_json(query, order_json)
    begin
      order = JSON.parse order_json
    rescue JSON::ParserError
      raise Error::BadRequest, code: 'PARAMS_ORDER_INVALID'
    end
    order.each { |name, type| query = query.safe_order name, type }
    query
  end

  def reduce_query(query)
    query = query_add_efilter_json query, params[:efilter] if params[:efilter].present?
    query = query_add_order_json query, params[:order] if params[:order].present?

    query = query.page(params[:page] || 1)
    query = query.per(params[:limit] || 25)

    query
  end

  def parse_param(param_name)
    return nil if params[param_name].blank?

    begin
      param = JSON.parse params[param_name]
    rescue JSON::ParserError => _e
      return nil
    end
    yield param
  end

  def authenticate_user
    # Method for overload
  end

  def authorize_user
    # Method for overload
  end
end
