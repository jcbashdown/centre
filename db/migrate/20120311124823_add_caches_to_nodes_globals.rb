class AddCachesToNodesGlobals < ActiveRecord::Migration
  def change
    add_column :nodes_globals, :upvotes_count, :integer, :default=>0, :null => false
    add_column :nodes_globals, :downvotes_count, :integer, :default=>0, :null => false
    add_column :nodes_globals, :equivalents_count, :integer, :default=>0, :null => false
    add_column :nodes_globals, :ignore, :boolean, :default=>true
    add_column :nodes_globals, :page_rank, :float, :default=>0
  end
end
