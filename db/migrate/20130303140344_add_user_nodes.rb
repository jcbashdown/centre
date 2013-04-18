class AddUserNodes < ActiveRecord::Migration
  def change
    create_table :user_nodes do |t|
      t.references :global_node
      t.references :user
      t.text :title
      t.integer :equivalents_count, :default=>0, :null => false
      t.integer :upvotes_count, :default=>0, :null => false
      t.integer :downvotes_count, :default=>0, :null => false
      t.integer :related_votes_count, :default=>0, :null => false
      t.integer :part_of_votes_count, :default=>0, :null => false
      t.integer :conclusion_votes_count, :default=>0, :null => false
      t.boolean :is_conclusion, :default=>false
      t.float :page_rank, :default=>0
      t.integer :users_count, :default=>0, :null => false
      t.boolean :private, :default=>false
      t.string :type

      t.timestamps
    end
    add_index :user_nodes, :user_id
    add_index :user_nodes, :type
  end
end
