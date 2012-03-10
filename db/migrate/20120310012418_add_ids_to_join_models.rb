class AddIdsToJoinModels < ActiveRecord::Migration
  def change
    add_column :nodes_globals, :id, :primary_key
    add_column :globals_links, :id, :primary_key
    add_column :globals_users, :id, :primary_key
  end
end
