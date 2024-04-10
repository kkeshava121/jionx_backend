class CreateModemSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :modem_settings, id: :uuid do |t|
      t.string :balance_check_USSD
      t.string :cash_in_USSD
      t.string :bank_id

      t.timestamps
    end
  end
end
