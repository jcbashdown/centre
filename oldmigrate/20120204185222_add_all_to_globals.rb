class AddAllToGlobals < ActiveRecord::Migration
  def change
    add_column :globals, :name, :string
  end
end
