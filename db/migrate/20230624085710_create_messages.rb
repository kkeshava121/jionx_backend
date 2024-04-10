class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages, id: :uuid do |t|
      t.string  :message_id
      t.string  :text_message
      t.string  :sender
      t.string  :receiver
      t.string  :sim_slot
      t.integer  :sms_type
      t.string  :android_id
      t.string  :app_version
      t.date  :sms_date
      t.boolean  :is_active
      t.string :user_id
      t.string :transaction_type
      t.timestamps
    end
  end
end
