class CreateNodeUsers < ActiveRecord::Migration
  def change
    create_table :node_users do |t|
      t.references :node
      t.references :user
      t.text :title
      t.text :body
      t.integer :global_node_users_count, :default=>0, :null => false
      t.integer :global_link_users_count, :default=>0, :null => false
      t.integer :equivalents_count, :default=>0, :null => false
      t.integer :upvotes_count, :default=>0, :null => false
      t.integer :downvotes_count, :default=>0, :null => false
      t.boolean :ignore, :default=>true
      t.boolean :is_conclusion, :default=>false
      t.float :page_rank, :default => 0.0

      t.timestamps
    end
  end
end
