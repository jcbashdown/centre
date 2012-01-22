class AddCounterCacheToLink < ActiveRecord::Migration
  def up
    add_column :links, :users_count, :integer, :default=>0, :null => false
  end
  def down
    remove_column :links, :users_count
  end
end
