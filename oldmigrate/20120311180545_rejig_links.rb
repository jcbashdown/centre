class RejigLinks < ActiveRecord::Migration
  def change
    add_column :links, :nodes_global_from_id, :integer
    add_column :links, :nodes_global_to_id, :integer
  end
end
