module ActiveRecord
  class Relation
    def safe_order(field, direction = 'asc')
      direction = direction.downcase.to_sym
      raise Error::CustomError, code: 'QUERY_ORDER_INVALID_DIRECTION' unless %i[asc desc].include?(direction)

      # field = connection.quote_table_name(field)
      order(field => direction)
    end
  end
end
