class AddMerchantIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :merchant_id, :string
  end
end
