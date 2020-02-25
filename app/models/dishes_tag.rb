class DishesTag < ApplicationRecord
  validates :dish_id, uniqueness: { scope: :tag }, presence: true
  validates :tag, length: { maximum: 32 }, presence: true

  has_many :dishes
end
