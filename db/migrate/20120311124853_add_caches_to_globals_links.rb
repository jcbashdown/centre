class AddCachesToGlobalsLinks < ActiveRecord::Migration
  def change
    add_column :globals_links, :users_count, :integer, :default=>0, :null => false
  end
end
