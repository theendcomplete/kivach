require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  subject(:i) do
    create(:ingredient)
  end

  it 'is valid with valid attributes' do
    expect(i).to be_valid
  end

  it 'is not valid without a name' do
    i.name = nil
    expect(i).to_not be_valid
  end

  it 'is not valid without a measurement_unit' do
    i.measurement_unit = nil
    expect(i).to_not be_valid
  end

  it 'is not valid to have 2 models with the same measurement_unit and name' do
    i_dup = i.dup
    expect(i_dup).to_not be_valid
  end
end
