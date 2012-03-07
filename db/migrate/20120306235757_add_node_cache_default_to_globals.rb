class AddNodeCacheDefaultToGlobals < ActiveRecord::Migration
  def change
    remove_column :globals, :nodes_count
    add_column :globals, :nodes_count, :integer, :default=>0
  end
end
