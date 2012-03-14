class AddGlobalIdToLink < ActiveRecord::Migration
  def change
    add_column :links, :global_id, :integer
  end
end
