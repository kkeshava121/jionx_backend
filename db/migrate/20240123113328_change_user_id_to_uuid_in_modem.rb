class ChangeUserIdToUuidInModem < ActiveRecord::Migration[7.0]
  def up
    # Change the data type of the user_id column to UUID
    change_column :modems, :user_id, :uuid, using: 'user_id::uuid'

    # Add an index on the user_id column
    add_index :modems, :user_id
  end

  def down
    # Revert the changes if needed (not recommended for data type changes)
    remove_index :modems, :user_id
    change_column :modems, :user_id, :string
  end
end
