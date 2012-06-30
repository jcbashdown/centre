class CreateNodeBodies < ActiveRecord::Migration
  def change
    create_table :node_bodies do |t|
      t.text :body

      t.timestamps
    end
  end
end
