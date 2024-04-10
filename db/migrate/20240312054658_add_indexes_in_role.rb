class AddIndexesInRole < ActiveRecord::Migration[7.0]
  def change
    add_index :roles, :id
    add_index :roles, :name
  end
end
