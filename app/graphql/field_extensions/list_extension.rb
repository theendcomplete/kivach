module FieldExtensions
  class ListExtension < GraphQL::Schema::FieldExtension
    def apply
      field.argument :options, InputObjects::ListOptions, required: false
    end

    def resolve(object:, arguments:, **_rest)
      yield(object, arguments, {})
    end

    def after_resolve(value:, arguments:, **_rest)
      options = arguments[:options]
      reduce_query(value, options)
    end

    private

    def query_efilter(query, filter)
      return query if filter.blank?

      query.efilter(filter)
    end

    def query_order(query, order)
      return query if order.blank?

      order.reduce(query) { |q, o| q.safe_order(o.first, o.last) }
    end

    def query_paginate(query, page, limit)
      query.page(page || 1).per(limit || 25)
    end

    def reduce_query(query, params)
      query = query_efilter(query, params[:efilter])
      query = query_order(query, params[:order])
      query_paginate(query, params[:page], params[:limit])
    end
  end
end
