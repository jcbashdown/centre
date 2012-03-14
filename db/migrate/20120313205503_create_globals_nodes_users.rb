class CreateGlobalsNodesUsers < ActiveRecord::Migration
  def change
    create_table :globals_nodes_users do |t|
      t.text :node_xml
      t.integer :user_id
      t.integer :global_id
      t.integer :node_id

      t.timestamps
    end
  end
end
