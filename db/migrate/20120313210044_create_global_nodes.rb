class CreateGlobalNodes < ActiveRecord::Migration
  def change
    create_table :global_nodes do |t|
      t.text :node_xml
      t.references :global
      t.references :node
      t.integer :equivalents_count, :default=>0, :null => false
      t.integer :upvotes_count, :default=>0, :null => false
      t.integer :downvotes_count, :default=>0, :null => false
      t.boolean :ignore, :boolean, :default=>true
      t.boolean :is_conclusion, :boolean, :default=>false
      t.float :page_rank
      t.integer :global_node_users_count, :default=>0, :null => false

      t.timestamps
    end
  end
end
