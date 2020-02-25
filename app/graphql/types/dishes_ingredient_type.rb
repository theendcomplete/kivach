module Types
  class DishesIngredientType < Types::BaseObject
    field :id, ID, null: false
    field :quantity, Float, null: true
    field :rank, Int, null: true
    field :name, String, null: false
    field :measurement_unit, String, null: false
    field :dish, DishType, null: false
    field :ingredient, IngredientType, null: false

    def name
      object.ingredient.name
    end

    delegate :dish, to: :object

    def measurement_unit
      object.ingredient.measurement_unit
    end
  end
end
