class CreateDishesPreferenceCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :dishes_preference_codes do |t|
      t.belongs_to :dish, null: false
      t.integer :preference_code, null: false

      t.timestamps

      t.index(%i[dish_id preference_code], unique: true)
    end
  end
end
