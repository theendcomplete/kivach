module Types
  class DishesPreferenceCodeType < Types::BaseObject
    field :id, ID, null: false
    field :preference_code, String, null: true
    field :dish, DishType, null: true

    delegate :dish, to: :object
  end
end
