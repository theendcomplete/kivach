class Ingredient < ApplicationRecord
  validates :name, length: { maximum: 100 }, presence: true
  validates :measurement_unit, length: { maximum: 100 }, presence: true
  validates :name, uniqueness: { scope: :measurement_unit }

  has_many :dishes_ingredients
  has_many :dishes, through: :dishes_ingredients
end
