class AddIsConclusionToNode < ActiveRecord::Migration
  def change
    add_column :nodes, :is_conclusion, :boolean, :default=>false
  end
end
