class CreateDishes < ActiveRecord::Migration[6.0]
  def change
    create_table :dishes do |t|
      t.string :name, null: false, limit: 100
      t.string :note, limit: 1_000
      t.integer :difficulty_level, null: false, default: 0, index: true
      t.integer :cooking_time, null: false, index: true
      t.integer :number_of_people, null: false, index: true
      t.integer :ready_weight, null: false, index: true
      t.decimal :kcal_per_100_grams, null: false
      t.decimal :protein_per_100_grams, null: false
      t.decimal :fat_per_100_grams, null: false
      t.decimal :carbohydrate_per_100_grams, null: false
      t.jsonb :recipe, null: false
      t.boolean :paid, null: false, index: true
      t.boolean :popular, null: false

      t.timestamps
    end
  end
end
