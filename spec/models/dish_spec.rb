require 'rails_helper'

RSpec.describe Dish, type: :model do
  subject(:dish) do
    build(:dish)
  end

  it 'is valid with valid attributes' do
    expect(dish).to be_valid
  end

  it 'is not valid without a name' do
    dish.name = nil
    expect(dish).to_not be_valid
  end

  it 'is valid without a note' do
    dish.note = nil
    expect(dish).to be_valid
  end

  it 'is not valid without a cooking_time' do
    dish.cooking_time = nil
    expect(dish).to_not be_valid
  end

  it 'is not valid without a number_of_people' do
    dish.number_of_people = nil
    expect(dish).to_not be_valid
  end

  it 'is not valid without a ready_weight' do
    dish.ready_weight = nil
    expect(dish).to_not be_valid
  end

  it 'is not valid without a kcal_per_100_grams' do
    dish.kcal_per_100_grams = nil
    expect(dish).to_not be_valid
  end

  it 'is not valid without a protein_per_100_grams' do
    dish.protein_per_100_grams = nil
    expect(dish).to_not be_valid
  end

  it 'is not valid without a fat_per_100_grams' do
    dish.fat_per_100_grams = nil
    expect(dish).to_not be_valid
  end

  it 'is not valid without a carbohydrate_per_100_grams' do
    dish.carbohydrate_per_100_grams = nil
    expect(dish).to_not be_valid
  end

  it 'is not valid with a protein_per_100_grams greater than 100' do
    dish.protein_per_100_grams = 101
    expect(dish).to_not be_valid
  end

  it 'is not valid with a fat_per_100_grams greater than 100' do
    dish.fat_per_100_grams = 101
    expect(dish).to_not be_valid
  end

  it 'is not valid with a carbohydrate_per_100_grams greater than 100' do
    dish.carbohydrate_per_100_grams = 101
    expect(dish).to_not be_valid
  end

  it 'is not valid with a note greater than 1000 symbols' do
    dish.note = 's' * 1_001
    expect(dish).to_not be_valid
  end

  it 'is not valid with a cooking_time greater than 1440 minutes' do
    dish.cooking_time = 1_441
    expect(dish).to_not be_valid
  end

  it 'is not valid with a number_of_people greater than 100' do
    dish.number_of_people = 101
    expect(dish).to_not be_valid
  end

  it 'is not valid with a number_of_people equal to zero' do
    dish.number_of_people = 0
    expect(dish).to_not be_valid
  end

  it 'is not valid with a ready_weight equal to zero' do
    dish.ready_weight = 0
    expect(dish).to_not be_valid
  end

  it 'is not valid with a kcal_per_100_grams greater than 1000' do
    dish.kcal_per_100_grams = 1_001
    expect(dish).to_not be_valid
  end
end
