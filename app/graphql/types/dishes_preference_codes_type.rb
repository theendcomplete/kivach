module Types
  class DishesPreferenceCodesType < Types::BaseObjectList
    field :rows, [Types::DishesPreferenceCodeType], null: false
  end
end
