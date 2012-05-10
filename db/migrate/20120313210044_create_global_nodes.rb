class CreateGlobalNodes < ActiveRecord::Migration
  def change
    create_table :global_nodes do |t|
      t.references :global
      t.references :node
      t.text :title
      t.text :body
      t.integer :equivalents_count, :default=>0, :null => false
      t.integer :upvotes_count, :default=>0, :null => false
      t.integer :downvotes_count, :default=>0, :null => false
      t.boolean :ignore, :default=>true
      t.boolean :is_conclusion, :default=>false
      t.float :page_rank, :default => 0.0
      t.integer :global_node_users_count, :default=>0, :null => false
      t.integer :global_link_users_count, :default=>0, :null => false

      t.timestamps
    end
  end
end
