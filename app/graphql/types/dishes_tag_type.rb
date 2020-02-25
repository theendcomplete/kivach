module Types
  class DishesTagType < Types::BaseObject
    field :id, ID, null: false
    field :tag, String, null: false
    field :dish, DishType, null: false
    field :created_at, Scalars::DateTime, null: false
    field :updated_at, Scalars::DateTime, null: false
  end
end
