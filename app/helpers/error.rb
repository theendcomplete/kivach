module Error
  class CustomError < StandardError
    attr_accessor :status
    attr_accessor :message
    attr_accessor :code
    attr_accessor :vars

    def initialize(params = {})
      self.status = :internal_server_error
      self.message = params[:message]
      self.code = params[:code]
      self.vars = params[:vars]
      render
      super(message)
    end

    def render
      self.code = 'UNKNOWN_ERROR' if code.blank?
      self.message = I18n.t("errors.codes.#{code}", default: code.tr('_', ' ').capitalize) if message.blank?
      if vars.is_a? Hash
        begin
          self.message = message % vars
        rescue KeyError
          self.message = nil
        end
      end
      self
    end
  end

  class Ok < CustomError
    def status
      :ok
    end
  end
  class BadRequest < CustomError
    def status
      :bad_request
    end
  end
  class Unauthorized < CustomError
    def status
      :unauthorized
    end
  end
  class PaymentRequired < CustomError
    def status
      :payment_required
    end
  end
  class Forbidden < CustomError
    def status
      :forbidden
    end
  end
  class NotFound < CustomError
    def status
      :not_found
    end
  end
  class Conflict < CustomError
    def status
      :conflict
    end
  end
  class InternalServerError < CustomError
    def status
      :internal_server_error
    end
  end
  class NotImplemented < CustomError
    def status
      :not_implemented
    end
  end
  class ServiceUnavailable < CustomError
    def status
      :service_unavailable
    end
  end
end
