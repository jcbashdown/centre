class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.references :user
      t.references :question
      t.references :global_link
      t.integer :global_node_from_id
      t.integer :global_node_to_id
      t.integer :users_count, :default=>0, :null => false
      t.boolean :active, :default=>false
      t.boolean :private, :default=>false
      t.string :type

      t.timestamps
    end
    add_index :links, :global_node_from_id
    add_index :links, :global_node_to_id
    add_index :links, :type
    add_index :links, :active
    add_index :links, :user_id
    add_index :links, :question_id
    add_index :links, :global_link_id
  end
end
