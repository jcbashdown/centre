class CreateGlobalNodeUsers < ActiveRecord::Migration
  def change
    create_table :global_node_users do |t|
      t.text :node_xml
      t.references :user
      t.references :global
      t.references :node
      t.references :node_user
      t.references :global_node
      t.string :title
      t.text :text
      t.integer :global_link_users_count, :default=>0, :null => false
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
