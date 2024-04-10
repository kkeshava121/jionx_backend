class ChangeDateTypeMessages < ActiveRecord::Migration[7.0]
  def change
    change_column(:messages, :sms_date, :datetime)
    change_column(:balance_managers, :date, :datetime)
  end
end
