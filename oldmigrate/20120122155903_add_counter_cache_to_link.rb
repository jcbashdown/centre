class AddCounterCacheToLink < ActiveRecord::Migration
  def change 
    add_column :links, :users_count, :integer, :default=>0, :null => false
  end
end
