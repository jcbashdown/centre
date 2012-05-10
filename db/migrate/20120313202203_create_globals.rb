class CreateGlobals < ActiveRecord::Migration
  def change
    create_table :globals do |t|
      t.string :name

      t.timestamps
    end
  end
end
