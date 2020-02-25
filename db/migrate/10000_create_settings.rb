class CreateSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :settings do |t|
      t.string :key, null: false, index: { unique: true }
      t.jsonb :value, index: true
      t.string :datatype, null: false, limit: 16

      t.timestamps
    end
  end
end
