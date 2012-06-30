class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.references :user
      t.references :question
      t.integer :node_from_id
      t.integer :node_to_id
      t.integer :users_count, :default=>0, :null => false
      t.integer :type
      t.boolean :active

      t.timestamps
    end
    add_index :links, :node_from_id
    add_index :links, :node_to_id
    add_index :links, :type
    add_index :links, :active
    add_index :links, :user_id
    add_index :links, :question_id
  end
end
