# frozen_string_literal: true

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

DIFF_LEVELS = { "Низкий": 'low', "Средний": 'medium', "Высокий": 'high' }.freeze
BOOLEAN_HASH = { "Да": 'true', "Нет": 'false' }.freeze
CATEGORY_CODES = { "Завтрак": 'breakfast', "Основное блюдо": 'main_dish',
                   "Десерт": 'dessert', "Закуска": 'side_dish', "Суп": 'soup',
                   "Смузи": 'smoothie', "Салат": 'salad', "Соус": 'sauce' }.freeze
PREFERENCE_CODES = { "Детокс": 'detox', "Без глютена": 'gluten_free',
                     "Без молока": 'milk_free', "Без сахара": 'sugar_free',
                     "Подходит вегетарианцам": 'vegetarian' }.freeze
IMAGES_DIR = Rails.root.join('import', 'images').freeze
IMAGE_SIZE = '708x400'

def prepare_string(string)
  string.to_s.strip.capitalize
end

xlsx = Roo::Excelx.new(Rails.root.join('import', 'recipes.xlsx'))
xlsx.each_with_pagename do |name, _sheet|
  puts "now importing from workbook #{name}"

  # Import dish
  dish_rows = (2..19).to_a
  dish_column = 2
  Dish.transaction do
    recipe_start_row = 25
    recipe_column = 1
    recipe = []

    (recipe_start_row..100).each do |rank|
      break if xlsx.excelx_value(rank, recipe_column).blank?

      recipe << { rank: rank - (recipe_start_row - 1), description: xlsx.excelx_value(rank, recipe_column).to_s.strip }
    end
    dish = Dish.where(name: prepare_string(xlsx.excelx_value(dish_rows[0], dish_column))).first_or_create
    if dish.update(note: xlsx.excelx_value(dish_rows[1], dish_column).to_s.strip,
                   difficulty_level: DIFF_LEVELS[prepare_string(xlsx.excelx_value(dish_rows[2], dish_column)).to_sym],
                   cooking_time: xlsx.excelx_value(dish_rows[3], dish_column),
                   number_of_people: xlsx.excelx_value(dish_rows[4], dish_column),
                   ready_weight: xlsx.excelx_value(dish_rows[5], dish_column),
                   kcal_per_100_grams: xlsx.excelx_value(dish_rows[6], dish_column),
                   protein_per_100_grams: xlsx.excelx_value(dish_rows[7], dish_column),
                   fat_per_100_grams: xlsx.excelx_value(dish_rows[8], dish_column),
                   carbohydrate_per_100_grams: xlsx.excelx_value(dish_rows[9], dish_column),
                   recipe: recipe,
                   paid: BOOLEAN_HASH[prepare_string(xlsx.excelx_value(dish_rows[10], dish_column)).to_sym],
                   popular: BOOLEAN_HASH[prepare_string(xlsx.excelx_value(dish_rows[11], dish_column)).to_sym])
      pp dish

      # Attach category codes
      if xlsx.excelx_value(dish_rows[12], dish_column).present?
        dish.dishes_category_codes.destroy_all
        categories = xlsx.excelx_value(dish_rows[12], dish_column).split(',').map(&:strip)
        categories.each do |category|
          category_code = DishesCategoryCode.new
          category_code.category_code = CATEGORY_CODES[prepare_string(category).to_sym]
          dish.dishes_category_codes << category_code
        end
      end
      pp dish.dishes_category_codes

      # Attach preference codes
      if xlsx.excelx_value(dish_rows[13], dish_column).present?
        dish.dishes_preference_codes.destroy_all
        preferences = xlsx.excelx_value(dish_rows[13], dish_column).split(',').map(&:strip)
        preferences.each do |preference|
          preference_code = DishesPreferenceCode.new
          preference_code.preference_code = PREFERENCE_CODES[prepare_string(preference).to_sym]
          dish.dishes_preference_codes << preference_code
        end
      end

      # Import ingredients
      ingredient_rows = (2..19)
      ingredient_columns = (4..6).to_a
      dish.dishes_ingredients.destroy_all
      rank = 1
      ingredient_rows.each do |row_index|
        next if xlsx.excelx_value(row_index, ingredient_columns[0]).blank?

        name = xlsx.excelx_value(row_index, ingredient_columns[0]).to_s.strip
        measurement_unit = xlsx.cell(row_index, ingredient_columns[1]).to_s.strip
        quantity = xlsx.cell(row_index, ingredient_columns[2])
        ingredient = Ingredient.where(name: name, measurement_unit: measurement_unit).first_or_create
        di = DishesIngredient.new
        di.rank = rank
        di.dish = dish
        di.ingredient = ingredient
        di.quantity = quantity
        dish.dishes_ingredients << di
        rank += 1
      end

      # Attach tags to dish
      dish.dishes_tags.destroy_all
      if xlsx.excelx_value(dish_rows[14], dish_column).present?
        tags = xlsx.excelx_value(dish_rows[14], dish_column).split(',').map(&:strip)
        tags.each do |tag|
          dishes_tag = DishesTag.new
          dishes_tag.tag = prepare_string(tag).to_sym
          dish.dishes_tags << dishes_tag
        end
      end

      # Attach images to dish
      if xlsx.excelx_value(dish_rows[15], dish_column).present?
        dish.images.each(&:purge)
        image_names = xlsx.excelx_value(dish_rows[15], dish_column).split(',').map(&:strip)
        image_names.each do |image_name|
          puts "Attaching image: #{IMAGES_DIR + image_name}"
          path = if File.file?(IMAGES_DIR + image_name)
                   (IMAGES_DIR + image_name)
                 else
                   (IMAGES_DIR + image_name.upcase)
                 end
          puts "File exists? #{File.file?(path)}"
          image = MiniMagick::Image.new(path)
          pp image
          image.resize(IMAGE_SIZE)

          dish.images.attach(io: File.open(image.path), filename: image_name)
        end
      end
    else
      pp "Список ошибок блюда:  #{dish.errors.messages}"
      raise 'Ошибка в файле импорта!'
    end
  end
end
puts "всего блюд: #{Dish.all.count}"
