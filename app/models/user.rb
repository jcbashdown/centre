class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  has_many :context_nodes

  has_many :user_groups
  has_many :groups, :through => :user_groups

  has_many :user_question_conclusions
  has_many :conclusions, :through => :user_question_conclusions

  def concluding_nodes(question)
    user_question_conclusions.where(:question_id => question.id).conclusions
  end

  def may_destroy(question)
    ContextNode.where("user_id != #{self.id}").where(:question_id => question.id).count == 0
  end
end
