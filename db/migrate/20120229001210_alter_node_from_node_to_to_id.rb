class AlterNodeFromNodeToToId < ActiveRecord::Migration
  def change
    rename_column :links, :node_from, :node_from_id
    rename_column :links, :node_to, :node_to_id
  end
end
