class CreateNodes < ActiveRecord::Migration
  def change
    create_table :nodes do |t|
      t.string :title
      t.text :text
      t.integer :equivalents_count, :default=>0, :null => false
      t.integer :upvotes_count, :default=>0, :null => false
      t.integer :downvotes_count, :default=>0, :null => false
      t.boolean :ignore, :boolean, :default=>true
      t.boolean :is_conclusion, :boolean, :default=>false
      t.float :page_rank
      t.integer :global_node_users_count, :default=>0, :null => false
      t.integer :global_link_users_count, :default=>0, :null => false

      t.timestamps
    end
  end
end
