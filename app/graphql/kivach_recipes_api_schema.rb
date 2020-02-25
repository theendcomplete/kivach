class KivachRecipesApiSchema < GraphQL::Schema
  rescue_from Error::Unauthorized do |e|
    raise e
  end

  rescue_from Error::Forbidden do |e|
    raise e
  end

  rescue_from Error::CustomError do |e|
    e = e.render
    ext = {}
    ext[:code] = e.code if e.code.present?
    ext[:vars] = e.vars if e.vars.present?
    GraphQL::ExecutionError.new(e.message, extensions: ext)
  end

  rescue_from ActiveRecord::ActiveRecordError do |e|
    ext = {}
    GraphQL::ExecutionError.new(e.message, extensions: ext)
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    ext = {}
    GraphQL::ExecutionError.new(e.message, extensions: ext)
  end

  mutation(Types::MutationType)
  query(Types::QueryType)
end
