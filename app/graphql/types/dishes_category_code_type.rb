module Types
  class DishesCategoryCodeType < Types::BaseObject
    field :id, ID, null: false
    field :category_code, String, null: false
    field :dish, DishType, null: false

    delegate :dish, to: :object
  end
end
