class AddPageRankToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :page_rank, :float
  end
end
