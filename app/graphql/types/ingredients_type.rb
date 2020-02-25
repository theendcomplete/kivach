module Types
  class IngredientsType < Types::BaseObjectList
    field :rows, [Types::IngredientType], null: false
  end
end
