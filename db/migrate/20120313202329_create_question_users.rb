class CreateQuestionUsers < ActiveRecord::Migration
  def change
    create_table :question_users do |t|
      t.references :question
      t.references :user
    end
    add_index :question_users, :question_id
    add_index :question_users, :user_id
  end
end
