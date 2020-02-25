class CreateIngredients < ActiveRecord::Migration[6.0]
  def change
    create_table :ingredients do |t|
      t.string :name, null: false, limit: 100
      t.string :measurement_unit, null: false, limit: 100

      t.timestamps

      t.index(%i[name measurement_unit], unique: true)
    end
  end
end
