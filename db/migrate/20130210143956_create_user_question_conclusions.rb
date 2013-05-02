class CreateUserQuestionConclusions < ActiveRecord::Migration
  def change
    create_table :user_question_conclusions do |t|
      t.integer :user_id
      t.integer :question_id
      t.integer :global_node_id

      t.timestamps
    end
  end
end
