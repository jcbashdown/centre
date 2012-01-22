class AddUserToNode < ActiveRecord::Migration
  def up
    add_column :nodes, :user_id, :integer
  end

  def down
    remove_column :nodes, :user_id
  end
end
