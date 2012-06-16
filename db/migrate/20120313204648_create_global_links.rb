class CreateGlobalLinks < ActiveRecord::Migration
  def change
    create_table :global_links do |t|
      t.references :global
      t.references :link
      t.integer :node_from_id
      t.integer :node_to_id
      t.integer :global_node_from_id
      t.integer :global_node_to_id
      t.integer :value
      t.boolean :active
      t.integer :global_link_users_count, :default=>0, :null => false

      t.timestamps
    end
  end
end
