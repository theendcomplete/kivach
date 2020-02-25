class DishesPreferenceCode < ApplicationRecord
  enum preference_code: { detox: 0, gluten_free: 1, milk_free: 2, sugar_free: 3, vegetarian: 4 }

  validates :preference_code, presence: true
  validates :dish_id, uniqueness: { scope: :preference_code }, presence: true
  has_one :dish
end
