class AddIndexToBm < ActiveRecord::Migration[7.0]
  def change
    add_index :balance_managers, :id
    add_index :balance_managers, :sender
    add_index :balance_managers, :b_type
    add_index :balance_managers, :customer_account_no
    add_index :balance_managers, :agent_account_no
    add_index :balance_managers, :old_balance
    add_index :balance_managers, :amount
    add_index :balance_managers, :commision
    add_index :balance_managers, :last_balance
    add_index :balance_managers, :transaction_id
    add_index :balance_managers, :status
    add_index :balance_managers, :date
    add_index :balance_managers, :user_id
    add_index :balance_managers, :created_at
  end
end
