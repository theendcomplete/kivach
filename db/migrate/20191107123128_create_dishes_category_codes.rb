class CreateDishesCategoryCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :dishes_category_codes do |t|
      t.belongs_to :dish, null: false
      t.integer :category_code, null: false
      t.index(%i[dish_id category_code], unique: true)

      t.timestamps
    end
  end
end
