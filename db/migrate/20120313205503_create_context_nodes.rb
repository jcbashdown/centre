class CreateContextNodes < ActiveRecord::Migration
  def change
    create_table :context_nodes do |t|
      t.references :question
      t.references :user
      t.references :global_node
      t.references :user_node
      t.references :question_node
      t.references :node_title
      t.text :title
      t.boolean :is_conclusion, :default=>false

      t.timestamps
    end
    add_index :context_nodes, :node_title_id
    add_index :context_nodes, :global_node_id
    add_index :context_nodes, :user_node_id
    add_index :context_nodes, :question_node_id
    add_index :context_nodes, :user_id
    add_index :context_nodes, :question_id
  end
end
