class CreateDishesTags < ActiveRecord::Migration[6.0]
  def change
    create_table :dishes_tags do |t|
      t.belongs_to :dish, null: false
      t.string :tag, limit: 32, null: false
      t.index(%i[dish_id tag], unique: true)

      t.timestamps
    end
  end
end
