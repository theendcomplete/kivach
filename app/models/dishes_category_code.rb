class DishesCategoryCode < ApplicationRecord
  enum category_code: { breakfast: 0, main_dish: 1, dessert: 2, side_dish: 3, soup: 4, smoothie: 5, salad: 6, sauce: 7 }

  validates :category_code, presence: true
  validates :dish_id, uniqueness: { scope: :category_code }, presence: true
end
