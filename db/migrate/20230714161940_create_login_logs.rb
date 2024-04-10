class CreateLoginLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :login_logs do |t|
      t.string :user_id, null: false
      t.datetime :login_time
      t.string :ip_address

      t.timestamps
    end
  end
end