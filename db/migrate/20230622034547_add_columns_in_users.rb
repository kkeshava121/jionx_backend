class AddColumnsInUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :full_name, :string
    add_column :users, :pin_code, :integer
    add_column :users, :country, :string
    add_column :users, :parent_id, :string
    add_column :users, :phone, :string
    add_column :users, :user_name, :string
    add_column :users, :company_id, :string
    add_column :users, :role_id, :string
  end
end
