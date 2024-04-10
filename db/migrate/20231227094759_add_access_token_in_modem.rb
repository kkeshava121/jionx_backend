class AddAccessTokenInModem < ActiveRecord::Migration[7.0]
  def change
    add_column :modems, :suspended, :boolean, default: true
    add_column :modems, :access_key, :string
  end
end