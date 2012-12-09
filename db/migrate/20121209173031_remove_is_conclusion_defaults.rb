class RemoveIsConclusionDefaults < ActiveRecord::Migration
  def up
    change_column_default(:nodes, :is_conclusion, nil)
    change_column_default(:context_nodes, :is_conclusion, nil)
  end

  def down
    change_column_default(:nodes, :is_conclusion, false)
    change_column_default(:context_nodes, :is_conclusion, false)
  end
end
