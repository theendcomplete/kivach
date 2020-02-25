module Types
  class DishesCategoryCodesType < Types::BaseObjectList
    field :rows, [Types::DishesCategoryCodeType], null: false
  end
end
