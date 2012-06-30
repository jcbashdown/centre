class CreateContextNodes < ActiveRecord::Migration
  def change
    create_table :context_nodes do |t|
      t.references :user
      t.references :question
      t.references :global_node
      t.references :node_title
      t.text :title
      t.integer :equivalents_count, :default=>0, :null => false
      t.integer :upvotes_count, :default=>0, :null => false
      t.integer :downvotes_count, :default=>0, :null => false
      t.boolean :is_conclusion, :default=>false

      t.timestamps
    end
  end
end
