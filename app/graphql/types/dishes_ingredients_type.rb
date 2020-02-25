module Types
  class DishesIngredientsType < Types::BaseObjectList
    field :rows, [Types::DishesIngredientType], null: false
  end
end
