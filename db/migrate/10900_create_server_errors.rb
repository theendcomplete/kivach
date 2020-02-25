class CreateServerErrors < ActiveRecord::Migration[5.2]
  def change
    create_table :server_errors do |t|
      t.text :message
      t.text :backtrace
      t.jsonb :extra
      t.string :request_token
      t.string :request_remote_ip
      t.string :request_method
      t.string :request_original_url
      t.string :request_params

      t.timestamps
    end
  end
end
