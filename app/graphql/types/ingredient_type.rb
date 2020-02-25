module Types
  class IngredientType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :dishes, DishesType, null: false
    field :rank, String, null: true
    field :measurement_unit, String, null: false

    delegate :dishes, to: :object
    delegate :rank, to: :object
  end
end
