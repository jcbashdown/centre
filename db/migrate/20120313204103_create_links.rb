class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.integer :node_from_id
      t.integer :node_to_id
      t.integer :users_count, :default=>0, :null => false
      t.integer :value

      t.timestamps
    end
  end
end
