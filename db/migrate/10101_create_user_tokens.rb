class CreateUserTokens < ActiveRecord::Migration[5.2]
  def change
    create_table(:user_tokens, primary_key: :token, id: false) do |t|
      t.string :token, null: false, index: { unique: true }
      t.references :user, foreign_key: true

      t.string :http_remote_addr, null: false
      t.string :http_user_agent, null: false

      t.timestamps
    end
    add_index :user_tokens, %i[token user_id]
  end
end
