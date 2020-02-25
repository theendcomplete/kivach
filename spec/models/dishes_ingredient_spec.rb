require 'rails_helper'

RSpec.describe DishesIngredient, type: :model do
  subject(:i) do
    dish = create(:dish)
    ingredient = create(:ingredient)

    described_class.create(rank: rand(1..1_000_000_000), created_at: Time.current, updated_at: Time.current,
                           dish: dish, ingredient: ingredient)
  end

  it 'has one dish' do
    expect(described_class.reflect_on_association(:dish).macro).to eq(:belongs_to)
  end

  it 'has one ingredient' do
    expect(described_class.reflect_on_association(:ingredient).macro).to eq(:belongs_to)
  end

  it 'is not valid without dish' do
    i.dish = nil
    expect(i).to_not be_valid
  end

  it 'is not valid without ingredient' do
    i.ingredient = nil
    expect(i).to_not be_valid
  end
end
