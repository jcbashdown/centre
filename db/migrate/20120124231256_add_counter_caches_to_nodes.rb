class AddCounterCachesToNodes < ActiveRecord::Migration
  def up
    add_column :nodes, :upvotes_count, :integer, :default=>0, :null => false
    add_column :nodes, :downvotes_count, :integer, :default=>0, :null => false
    add_column :nodes, :equivalents_count, :integer, :default=>0, :null => false
  end
  def down
    remove_column :nodes, :upvotes_count
    remove_column :nodes, :downvotes_count
    remove_column :nodes, :equivalents_count
  end
end
