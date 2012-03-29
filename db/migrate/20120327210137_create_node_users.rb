class CreateNodeUsers < ActiveRecord::Migration
  def change
    create_table :node_users do |t|
      t.references :node
      t.references :user
      t.integer :global_node_users_count

      t.timestamps
    end
  end
end
