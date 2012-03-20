class CreateGlobalNodeUsers < ActiveRecord::Migration
  def change
    create_table :global_node_users do |t|
      t.text :node_xml
      t.references :user
      t.references :global
      t.references :node

      t.timestamps
    end
  end
end