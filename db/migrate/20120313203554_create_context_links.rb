class CreateContextLinks < ActiveRecord::Migration
  def change
    create_table :context_links do |t|
      t.references :question
      t.references :user
      t.references :global_link
      t.integer :global_node_from_id
      t.integer :global_node_to_id
      t.integer :context_node_from_id
      t.integer :context_node_to_id
      t.integer :question_node_from_id
      t.integer :question_node_to_id
      t.integer :node_user_from_id
      t.integer :node_user_to_id
      t.integer :type

      t.timestamps
    end
    add_index :context_links, :question_id
    add_index :context_links, :user_id
    add_index :context_links, :global_link_id
    add_index :context_links, :type
    #intersection index really needed here
  end
end
