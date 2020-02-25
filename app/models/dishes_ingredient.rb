class DishesIngredient < ApplicationRecord
  belongs_to :dish
  belongs_to :ingredient

  validates :dish, uniqueness: { scope: :ingredient }, presence: true
  validates :dish, uniqueness: { scope: :rank }, presence: true
end
