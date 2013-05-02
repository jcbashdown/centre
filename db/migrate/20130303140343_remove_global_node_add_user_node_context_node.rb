class RemoveGlobalNodeAddUserNodeContextNode < ActiveRecord::Migration
  def up
    remove_index :context_nodes, :global_node_id
    remove_column :context_nodes, :global_node_id
    add_column :context_links, :user_node_id, :integer
    add_index :context_links, :user_node_id
  end

  def down
    remove_index :context_nodes, :user_node_id
    remove_column :context_nodes, :user_node_id
    add_column :context_links, :global_node_id, :integer
    add_index :context_links, :global_node_id
  end
end
