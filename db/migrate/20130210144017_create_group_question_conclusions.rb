class CreateGroupQuestionConclusions < ActiveRecord::Migration
  def change
    create_table :group_question_conclusions do |t|
      t.integer :group_id
      t.integer :question_id
      t.integer :global_node_id

      t.timestamps
    end
  end
end
