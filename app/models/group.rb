class Group < ActiveRecord::Base
  attr_accessible :about, :title

  has_many :user_groups
  has_many :users, :through => :user_groups

  has_many :group_question_conclusions
  has_many :conclusions, :through => :group_question_conclusions

  def concluding_nodes(question)
    conclusions.by_question_for_group(question)
  end

  def user_ids
    users.map(&:id)
  end

  class << self
    def user_ids_for id
      Group.find(id).user_ids
    end
  end
    
end
