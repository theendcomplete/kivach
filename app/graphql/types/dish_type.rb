module Types
  class DishType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :note, String, null: true
    field :number_of_people, Int, null: false
    field :cooking_time, Int, null: false
    field :difficulty_level, String, null: false
    field :ready_weight, Int, null: false
    field :kcal_per_100_grams, Float, null: false
    field :protein_per_100_grams, Float, null: false
    field :fat_per_100_grams, Float, null: false
    field :carbohydrate_per_100_grams, Float, null: false
    field :recipe, GraphQL::Types::JSON, null: false
    field :recipe_string, String, null: false
    field :paid, Boolean, null: false
    field :popular, Boolean, null: false
    field :created_at, Scalars::DateTime, null: false
    field :updated_at, Scalars::DateTime, null: false
    field :dishes_ingredients, Types::DishesIngredientsType, null: false
    field :ingredients, Types::IngredientsType, null: false
    field :dishes_preference_codes, Types::DishesPreferenceCodesType, null: false
    field :dishes_tags, Types::DishesTagsType, null: true
    field :dishes_category_codes, Types::DishesCategoryCodesType, null: false
    field :image_links, [String], null: true

    def image_links
      urls = []
      object.images.each do |image|
        urls << Rails.application.routes.url_helpers.rails_blob_url(image)
      end
      urls
    end

    def recipe_string
      object.recipe.to_s
    end
  end
end
