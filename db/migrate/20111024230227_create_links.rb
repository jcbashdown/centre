class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.integer :node_from
      t.boolean :value
      t.integer :user_id
      t.integer :node_to

      t.timestamps
    end
  end
end
