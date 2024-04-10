class AddIndexToMessage < ActiveRecord::Migration[7.0]
  def change
    add_index :messages, :id
    add_index :messages, :text_message
    add_index :messages, :sender
    add_index :messages, :receiver
    add_index :messages, :sim_slot
    add_index :messages, :user_id
    add_index :messages, :created_at
    add_index :messages, :sms_date
    add_index :messages, :transaction_type
  end
end