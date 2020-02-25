def populate_database
  images_dir = Rails.root.join('import', 'images', '*.jpg').freeze

  101.times do
    Ingredient.create(name: Faker::Food.ingredient, measurement_unit: Faker::Food.metric_measurement,
                      created_at: Time.current, updated_at: Time.current)
  end

  40.times do
    receipt = JSON.parse('[{"rank": 1, "description": "Отвариваем рис. Сливаем воду."}, {"rank": 2, "description": "Добавляем молоко и варим рисовую кашу."}, {"rank": 3, "description": "Белок взбиваем в пену и вводим в остывшую кашу."}, {"rank": 4, "description": "Выкладываем полученную смесь в емкость для запекания. Сверху выкладываем бруснику. Запекаем при температуре 180 градусов 5 минут."}, {"rank": 5, "description": "Яблоко запекаем при 180 градусах 10 минут. "}, {"rank": 6, "description": "На тарелку выкладываем пудинг и запеченное яблоко, посыпанное измельченной сухой малиной. Декорируем мятой."}]')
    dish = Dish.create(name: Faker::Food.dish, note: Faker::Food.description,
                       difficulty_level: Dish.difficulty_levels[%i[low medium high].sample], cooking_time: rand(1..1_440),
                       number_of_people: rand(0..100),   ready_weight: rand(0..10_000), kcal_per_100_grams: rand(0..1_000),
                       protein_per_100_grams: rand(0..100), fat_per_100_grams: rand(0..100), carbohydrate_per_100_grams: rand(0..100),
                       paid: [true, false].sample, popular: [true, false].sample, recipe: receipt,
                       created_at: Time.current, updated_at: Time.current)
    rand(1..10).times do |index|
      ingredient = Ingredient.find(rand(1..99))
      DishesIngredient.create(rank: index + 1, quantity: rand(1..1_000), created_at: Time.current, updated_at: Time.current,
                              dish: dish, ingredient: ingredient)
    end

    rand(1..4).times do
      dt = DishesTag.new(tag: Faker::Movies::HarryPotter.spell)
      dish.dishes_tags << dt
    end
    rand(1..4).times do
      pref_codes = %w[detox gluten_free milk_free sugar_free vegetarian]
      dp = DishesPreferenceCode.new(preference_code: pref_codes.sample)
      dish.dishes_preference_codes << dp
    end
    rand(1..2).times do
      cat_codes = %w[breakfast main_dish dessert side_dish soup smoothie]
      cc = DishesCategoryCode.new(category_code: cat_codes.sample)
      dish.dishes_category_codes << cc
    end
    images = Dir[images_dir.to_s]
    image = images.sample
    image = MiniMagick::Image.new((image).to_s)
    image.resize(IMAGE_SIZE)

    dish.images.attach(io: File.open(image.path), filename: image)
  end
end
