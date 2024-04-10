class AddIsPrivacyToBalanceManagers < ActiveRecord::Migration[7.0]
  def change
    add_column :balance_managers, :is_privacy, :boolean, default: false
  end
end