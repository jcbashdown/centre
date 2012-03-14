class CreateGlobals < ActiveRecord::Migration
  def change
    create_table :globals do |t|
      t.string :name
      t.text :nodes_xml

      t.timestamps
    end
  end
end
