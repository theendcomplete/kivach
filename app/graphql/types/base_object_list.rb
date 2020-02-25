module Types
  class BaseObjectList < Types::BaseObject
    field :total_count, Integer, null: false

    def rows
      object
    end

    def total_count
      object.unscope(:limit, :offset, :order).size
    end
  end
end
