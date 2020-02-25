module Resolvers
  class BaseResolver < GraphQL::Schema::Resolver
    argument_class Arguments::BaseArgument
  end
end
