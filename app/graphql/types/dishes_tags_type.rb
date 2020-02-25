module Types
  class DishesTagsType < Types::BaseObjectList
    field :rows, [Types::DishesTagType], null: false
  end
end
