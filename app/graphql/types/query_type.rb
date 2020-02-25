module Types
  class QueryType < Types::BaseObject
    field :dishes, type: Types::DishesType, null: false,
          extensions: [FieldExtensions::ListExtension]

    def dishes(options:)
      dishes = ActiveRecord::Relation.new(Dish)
      if %i[category preferences ingredients tags].any? { |s| options.key?(s) }
        # make requests to db
        dishes = Dish.joins(:dishes_category_codes).where(dishes_category_codes: { category_code: options[:category] }).merge(dishes) if options[:category]&.count&.positive?
        dishes = Dish.joins(:dishes_preference_codes).where(dishes_preference_codes: { preference_code: options[:preferences] }).merge(dishes) if options[:preferences]&.count&.positive?
        dishes = Dish.joins(:ingredients).where(ingredients: { name: options[:ingredients] }).merge(dishes) if options[:ingredients]&.count&.positive?
        dishes = Dish.joins(:dishes_tags).where(dishes_tags: { tag: options[:tags] }).merge(dishes) if options[:tags]&.count&.positive?
      else
        dishes = Dish.all.merge(dishes)
      end
      dishes
    end

    field :ingredients, Types::IngredientsType, null: false,
          description: 'Return a list of all ingredients',
          extensions: [FieldExtensions::ListExtension]

    def ingredients(options:)
      Ingredient.all
    end

    field :dishes_ingredients, Types::DishesIngredientsType,
          null: false, description: 'Return a list of all ingredients associated with dishes',
          extensions: [FieldExtensions::ListExtension]

    def dishes_ingredients(options:)
      DishesIngredient.all
    end

    field :dishes_preference_codes, Types::DishesPreferenceCodesType,
          null: false, description: 'Return a list of all dishes preference codes with dishes',
          extensions: [FieldExtensions::ListExtension]

    def dishes_preference_codes(options:)
      DishesPreferenceCode.preload(:dish)
    end

    field :dishes_tags, Types::DishesTagsType,
          null: false,
          description: 'Return a list of all tags with dishes',
          extensions: [FieldExtensions::ListExtension]

    def dishes_tags(options:)
      DishesTag.all
    end

    field :dishes_category_codes, Types::DishesCategoryCodesType,
          null: false,
          description: 'Return a list of all category codes',
          extensions: [FieldExtensions::ListExtension]

    def dishes_category_codes(options:)
      DishesCategoryCode.preload(:dishes)
    end
  end
end
