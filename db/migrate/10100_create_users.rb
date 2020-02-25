class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :login, null: false, limit: 48, index: { unique: true }
      t.string :email, limit: 48, index: { unique: false }
      t.string :phone, limit: 48, index: { unique: false }
      t.string :password_digest, null: false, limit: 1_024

      t.string :first_name, limit: 48
      t.string :last_name, limit: 48

      t.string :status_code, null: false, limit: 64
      t.string :role_code, null: false, limit: 64

      t.integer :auth_attempts, null: false, default: 0
      t.timestamp :auth_blocked_until

      t.timestamp :password_updated_at
      t.timestamp :archived_at
      t.timestamps

      t.index :status_code
      t.index :role_code
    end
  end
end
