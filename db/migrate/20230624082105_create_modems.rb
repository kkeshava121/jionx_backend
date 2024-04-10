class CreateModems < ActiveRecord::Migration[7.0]
  def change
    create_table :modems, id: :uuid do |t|
      t.string :sim_type
      t.string :operator
      t.string :phone_number
      t.string :device_id
      t.integer :sim_id
      t.string :token
      t.string :device_info
      t.boolean :is_active
      t.string :user_id
      t.integer :modem_action
      t.integer :pincode
      t.timestamps
    end
  end
end
