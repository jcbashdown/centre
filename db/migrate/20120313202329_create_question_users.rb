class CreateQuestionUsers < ActiveRecord::Migration
  def change
    create_table :question_users do |t|
      t.references :question
      t.references :user
    end
  end
end
