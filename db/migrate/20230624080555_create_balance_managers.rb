class CreateBalanceManagers < ActiveRecord::Migration[7.0]
  def change
    create_table :balance_managers, id: :uuid do |t|
      t.string :sender, null: false
      t.string :b_type, null: false
      t.bigint :customer_account_no, null: false
      t.bigint :agent_account_no, null: false
      t.decimal :old_balance, precision: 18, scale: 10, null: false
      t.decimal :amount, precision: 18, scale: 10, null: false
      t.decimal :commision, precision: 18, scale: 10, null: false
      t.decimal :last_balance, precision: 18, scale: 10, null: false
      t.string :transaction_id, null: false
      t.integer :status, null: false
      t.date :date, null: false
      t.string :message, null: false, default: ''
      t.string :user_id
      t.timestamps
    end
  end
end
