class AddIndexesInModems < ActiveRecord::Migration[7.0]
  def change
    add_index :modems, :id
    add_index :modems, :sim_type
    add_index :modems, :operator
    add_index :modems, :phone_number
    add_index :modems, :device_id
    add_index :modems, :sim_id
    add_index :modems, :token
    add_index :modems, :device_info
    add_index :modems, :is_active
    add_index :modems, :pincode
    add_index :modems, :created_at
    add_index :modems, :suspended
    add_index :modems, :access_key
  end
end
