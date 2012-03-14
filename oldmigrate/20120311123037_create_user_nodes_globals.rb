class CreateUserNodesGlobals < ActiveRecord::Migration
  def change
    create_table :user_nodes_globals do |t|
      t.text :votes_xml
      t.integer :user_id
      t.integer :nodes_global_id

      t.timestamps
    end
  end
end
