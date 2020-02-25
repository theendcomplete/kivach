class CreateUserActionTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :user_action_tokens do |t|
      t.string :token, null: false, limit: 256
      t.string :type_code, null: false, limit: 64
      t.references :user, foreign_key: true, null: false
      t.timestamp :expires_at

      t.timestamps
    end
  end
end
