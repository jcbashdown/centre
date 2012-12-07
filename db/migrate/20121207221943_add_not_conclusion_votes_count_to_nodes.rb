class AddNotConclusionVotesCountToNodes < ActiveRecord::Migration
  def change
    add_column :nodes, :not_conclusion_votes_count, :integer, :default => 0, :null => false
  end
end
