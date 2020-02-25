module Scalars
  class DateTime < Scalars::BaseScalar
    def self.coerce_input(value, _context)
      Time.zone.parse(value)
    end

    def self.coerce_result(value, _context)
      value.iso8601
    end
  end
end
