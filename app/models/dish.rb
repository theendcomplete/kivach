class Dish < ApplicationRecord
  validates :name, length: { maximum: 100 }, presence: true
  validates :note, length: { maximum: 1_000 }
  validates :cooking_time, inclusion: 1..1_440, presence: true
  validates :number_of_people, inclusion: 1..100, presence: true
  validates :ready_weight, inclusion: 1..10_000, presence: true
  validates :kcal_per_100_grams, inclusion: 0..1_000, presence: true
  validates :protein_per_100_grams, inclusion: 0..100, presence: true
  validates :fat_per_100_grams, inclusion: 0..100, presence: true
  validates :carbohydrate_per_100_grams, inclusion: 0..100, presence: true

  enum difficulty_level: { low: 0, medium: 1, high: 2 }

  has_many :dishes_ingredients
  has_many :ingredients, through: :dishes_ingredients
  has_many :dishes_category_codes
  has_many :dishes_preference_codes
  has_many :dishes_tags
  has_many_attached :images
end
