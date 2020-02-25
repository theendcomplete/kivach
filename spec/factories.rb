true_false_array = [true, false].freeze

FactoryBot.define do
  factory :ingredient do
    name { Faker::Food.ingredient }
    measurement_unit { Faker::Food.metric_measurement }
    created_at { Time.current }
    updated_at { Time.current }
  end

  factory :dish do
    name { Faker::Food.dish }
    note { Faker::Food.description }
    difficulty_level { Dish.difficulty_levels[%i[low medium high].sample] }
    cooking_time { rand(1..1_440) }
    number_of_people { rand(0..100) }
    ready_weight { rand(0..10_000) }
    kcal_per_100_grams { rand(0..1_000) }
    protein_per_100_grams { rand(0..100) }
    fat_per_100_grams { rand(0..100) }
    carbohydrate_per_100_grams { rand(0..100) }
    paid { true_false_array.sample }
    popular { true_false_array.sample }
    recipe { '[{"rank": 1, "description": "Отвариваем рис. Сливаем воду."}, {"rank": 2, "description": "Добавляем молоко и варим рисовую кашу."}, {"rank": 3, "description": "Белок взбиваем в пену и вводим в остывшую кашу."}, {"rank": 4, "description": "Выкладываем полученную смесь в емкость для запекания. Сверху выкладываем бруснику. Запекаем при температуре 180 градусов 5 минут."}, {"rank": 5, "description": "Яблоко запекаем при 180 градусах 10 минут. "}, {"rank": 6, "description": "На тарелку выкладываем пудинг и запеченное яблоко, посыпанное измельченной сухой малиной. Декорируем мятой."}]' }
    created_at { Time.current }
    updated_at { Time.current }
  end
end
