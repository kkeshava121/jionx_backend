class AddIndexesInBank < ActiveRecord::Migration[7.0]
  def change
    add_index :banks, :id
    add_index :banks, :bank_name
    add_index :banks, :created_at
  end
end
