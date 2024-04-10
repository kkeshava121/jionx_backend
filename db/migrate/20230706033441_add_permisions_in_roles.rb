class AddPermisionsInRoles < ActiveRecord::Migration[7.0]
  def change
    add_column :roles, :permissions, :json
  end
end
