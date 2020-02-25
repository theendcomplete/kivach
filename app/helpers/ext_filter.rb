class ExtFilter
  attr_accessor :relation
  attr_accessor :conn
  attr_accessor :filter

  def initialize(arg_relation, arg_filter)
    self.relation = arg_relation
    self.conn = relation.connection

    self.filter = arg_filter
  end

  def to_s
    parse_filter
  end

  private

  def parse_field_value(args)
    field, value = args
    raise Error::CustomError, code: 'QUERY_EFILTER_EMPTY_FIELD' if field.blank?
    raise Error::CustomError, code: 'QUERY_EFILTER_EMPTY_VALUE' if value.blank?

    field = conn.quote_table_name(field)
    if value.is_a?(Array)
      value = value.map { |v| conn.quote(v) }
    elsif value.is_a?(Hash)
      raise Error::CustomError, code: 'QUERY_EFILTER_INVALID_VALUE'
    else
      value = conn.quote(value)
    end

    [field, value]
  end

  def parse_filter(arg_filter = filter)
    # {operator: [arg1, arg2, arg3]}
    # {operator: {arg}}
    raise Error::CustomError, code: 'QUERY_EFILTER_INVALID' unless arg_filter.is_a?(Hash) && arg_filter.keys.length == 1

    operator, args = arg_filter.first
    case operator.to_s.downcase
    when 'not'
      query = parse_filter(args)
      "NOT (#{query})"
    when 'and'
      args.map do |arg|
        query = parse_filter(arg)
        "(#{query})"
      end.join(' AND ')
    when 'or'
      args.map do |arg|
        query = parse_filter(arg)
        "(#{query})"
      end.join(' OR ')
    when 'eq'
      field, value = parse_field_value(args)
      "#{field} = #{value}"
    when 'lt'
      field, value = parse_field_value(args)
      "#{field} < #{value}"
    when 'le'
      field, value = parse_field_value(args)
      "#{field} <= #{value}"
    when 'gt'
      field, value = parse_field_value(args)
      "#{field} > #{value}"
    when 'ge'
      field, value = parse_field_value(args)
      "#{field} >= #{value}"
    when 'is'
      field, value = parse_field_value(args)
      if %w[NULL TRUE FALSE].includes? value
        "#{field} IS #{value}"
      else
        raise Error::CustomError, code: 'QUERY_EFILTER_INVALID_IS_VALUE'
      end
    when 'in'
      field, values = parse_field_value(args)
      raise Error::CustomError, code: 'QUERY_EFILTER_INVALID_IN_VALUE' unless values.is_a? Array

      "#{field} IN (#{values.join(',')})"
    when 'like'
      field, value = parse_field_value(args)
      "#{field}::TEXT LIKE #{value}"
    when 'ilike'
      field, value = parse_field_value(args)
      "#{field}::TEXT ILIKE #{value}"
    when 'substr'
      field, value = parse_field_value(args)
      value = value.gsub(/$(')/, "'%").gsub(/(')^/, "%'")
      "#{field}::TEXT ILIKE #{value}"
    else
      raise Error::CustomError, code: 'QUERY_EFILTER_INVALID_OPERATOR'
    end
  end
end
