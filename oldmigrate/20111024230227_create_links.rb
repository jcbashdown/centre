class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.integer :node_from
      t.integer :value
      t.integer :node_to

      t.timestamps
    end
  end
end
