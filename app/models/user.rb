class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  has_many :context_nodes

  def concluding_nodes(question)
    ContextNode.where(:user_id => self.id, :question_id => question.id, :is_conclusion => true)#.collect(&:global_node_id)
    #Node::GlobalNode.where('id IN (?)', gn_ids)
  end

  def may_destroy(question)
    ContextNode.where("user_id != #{self.id}").where(:question_id => question.id).count == 0
  end
end
