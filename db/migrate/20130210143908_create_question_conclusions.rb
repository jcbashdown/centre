class CreateQuestionConclusions < ActiveRecord::Migration
  def change
    create_table :question_conclusions do |t|
      t.integer :question_id
      t.integer :global_node_id

      t.timestamps
    end
  end
end
