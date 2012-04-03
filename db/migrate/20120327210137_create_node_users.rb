class CreateNodeUsers < ActiveRecord::Migration
  def change
    create_table :node_users do |t|
      t.references :node
      t.references :user
      t.string :title
      t.text :text
      t.integer :global_node_users_count, :default=>0, :null => false
      t.integer :equivalents_count, :default=>0, :null => false
      t.integer :upvotes_count, :default=>0, :null => false
      t.integer :downvotes_count, :default=>0, :null => false
      t.boolean :ignore, :boolean, :default=>true
      t.boolean :is_conclusion, :boolean, :default=>false
      t.float :page_rank

      t.timestamps
    end
  end
end
