class CreateContextNodes < ActiveRecord::Migration
  def change
    create_table :context_nodes do |t|
      #activity log, for callbacks (could do without db)
      t.references :question
      t.references :user
      t.text :title
      # for user counts, know if destroy
      t.references :global_node
      t.references :user_node
      t.references :question_node
      #is this hacky? for not adding to counter cache
      t.integer :private_global_node_id
      t.integer :private_user_node_id
      t.integer :private_question_node_id
      #ensure all sub refer to same node
      t.references :node_title
      #for is conclusion on sub but doesn't tell us whether actually conclusion. do like private?
      t.boolean :is_conclusion, :default=>false
      t.boolean :private, :default=>false

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
