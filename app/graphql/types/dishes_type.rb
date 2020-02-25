module Types
  class DishesType < Types::BaseObjectList
    field :rows, [Types::DishType], null: false
  end
end
