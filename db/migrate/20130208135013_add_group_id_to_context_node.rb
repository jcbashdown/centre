class AddGroupIdToContextNode < ActiveRecord::Migration
  def change
    add_column :context_nodes, :group_id, :integer
    add_column :context_nodes, :group_node_id, :integer
    add_index :context_nodes, :group_id
    add_index :context_nodes, :group_node_id
  end
end
