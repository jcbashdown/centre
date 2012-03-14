class CreateGlobals < ActiveRecord::Migration
  def change
    create_table :globals do |t|
      t.integer :nodes_count

      t.timestamps
    end
  end
end
