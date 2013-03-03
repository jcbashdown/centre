class Group < ActiveRecord::Base
  attr_accessible :about, :title

  has_many :user_groups
  has_many :users, :through => :user_groups

  has_many :group_question_conclusions
  has_many :conclusions, :through => :group_question_conclusions

  def concluding_nodes(question)
    conclusions.where(:question_id => question.id)
  end
end
