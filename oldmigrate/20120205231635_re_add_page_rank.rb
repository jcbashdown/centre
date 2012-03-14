class ReAddPageRank < ActiveRecord::Migration
  def up
    add_column :nodes, :page_rank, :float, :default=>0
  end

  def down
    remove_column :nodes, :page_rank
  end
end
