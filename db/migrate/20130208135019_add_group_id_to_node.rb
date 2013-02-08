class AddGroupIdToNode < ActiveRecord::Migration
  def change
    add_column :nodes, :group_id, :integer
    add_index :nodes, :group_id
  end
end
