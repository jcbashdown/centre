class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.references :user
      t.integer :other_link_id
      t.integer :other_node_from_id
      t.integer :other_node_to_id
      t.integer :node_from_id
      t.integer :node_to_id
      t.boolean :private, :default=>false
      t.string :type

      t.timestamps
    end
    add_index :links, :global_node_from_id
    add_index :links, :global_node_to_id
    add_index :links, :node_from_id
    add_index :links, :node_to_id
    add_index :links, :type
    add_index :links, :active
    add_index :links, :user_id
    add_index :links, :question_id
    add_index :links, :global_link_id
  end
end
