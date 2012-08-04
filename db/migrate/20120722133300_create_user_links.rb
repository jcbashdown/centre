class CreateUserLinks < ActiveRecord::Migration
  def change
    create_table :user_links do |t|
      t.references :user
      t.references :question
      t.integer :other_link_id
      t.integer :other_node_from_id
      t.integer :other_node_to_id
      t.integer :node_from_id
      t.integer :node_to_id
      t.boolean :private, :default=>false
      t.string :type

      t.timestamps
    end
    add_index :user_links, :other_node_from_id
    add_index :user_links, :other_node_to_id
    add_index :user_links, :node_from_id
    add_index :user_links, :node_to_id
    add_index :user_links, :type
    add_index :user_links, :user_id
    add_index :user_links, :question_id
    add_index :user_links, :other_link_id
  end
end
