class CreateNodesGlobals < ActiveRecord::Migration
  def change 
    create_table :nodes_globals, :id => false do |t|
      t.integer :node_id
      t.integer :global_id
    end
  end
end
