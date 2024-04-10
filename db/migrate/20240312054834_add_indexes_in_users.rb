class AddIndexesInUsers < ActiveRecord::Migration[7.0]
  def change
    add_index :users, :id
    add_index :users, :full_name
    add_index :users, :created_at
    add_index :users, :pin_code
    add_index :users, :parent_id
    add_index :users, :phone
    add_index :users, :company_id
    add_index :users, :role_id
    add_index :users, :merchant_id
  end
end
