class AddGroupIdToContextLink < ActiveRecord::Migration
  def change
    add_column :context_links, :group_id, :integer
    add_column :context_links, :group_link_id, :integer
    add_column :context_links, :group_node_from_id, :integer
    add_column :context_links, :group_node_to_id, :integer
    remove_column :context_links, :question_link_id
    add_index :context_links, :group_id
    add_index :context_links, :group_link_id
    add_index :context_links, :group_node_from_id
    add_index :context_links, :group_node_to_id
  end
end
