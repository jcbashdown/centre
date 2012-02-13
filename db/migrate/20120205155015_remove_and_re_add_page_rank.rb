class RemoveAndReAddPageRank < ActiveRecord::Migration
  def up
    remove_column :nodes, :page_rank
  end

  def down
    add_column :nodes, :page_rank, :float
  end
end