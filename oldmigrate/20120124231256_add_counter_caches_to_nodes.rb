class AddCounterCachesToNodes < ActiveRecord::Migration
  def change 
    add_column :nodes, :upvotes_count, :integer, :default=>0, :null => false
    add_column :nodes, :downvotes_count, :integer, :default=>0, :null => false
    add_column :nodes, :equivalents_count, :integer, :default=>0, :null => false
  end
end
