require 'rails_helper'
RSpec.describe DishesCategoryCode, type: :model do
  subject(:cc) do
    described_class.create(category_code: described_class.category_codes[%i[breakfast main_dish dessert side_dish soup smoothie salad sauce].sample],
                           created_at: Time.current, updated_at: Time.current)
  end

  it 'has has_one dish' do
    expect(described_class.reflect_on_association(:dish).macro).to eq(:has_one)
  end

  it 'can be applied to dish' do
    d = create(:dish)
    d.dishes_category_codes << cc
    expect(d.dishes_category_codes.size).to be_equal(1)
  end

  it 'can\'t be saved with the same params' do
    d = create(:dish)
    d.dishes_category_codes << cc
    cc_clone = cc.dup
    expect(cc_clone).to_not be_valid
  end
end
