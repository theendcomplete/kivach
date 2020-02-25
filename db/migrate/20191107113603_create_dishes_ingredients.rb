class CreateDishesIngredients < ActiveRecord::Migration[6.0]
  def change
    create_table :dishes_ingredients do |t|
      t.belongs_to :dish, null: false
      t.belongs_to :ingredient, null: false
      t.integer :rank, default: 1, null: false
      t.decimal :quantity, default: 0, null: false

      t.timestamps

      t.index(%i[dish_id ingredient_id], unique: true)
      t.index(%i[dish_id rank], unique: true)
    end
  end
end
