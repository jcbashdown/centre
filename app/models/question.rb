class Question < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true, :format => { :with => /^((?!all).)*$/i,
    :message => "Please use the pre defined 'All'" }

  has_many :question_conclusions
  has_many :concluding_nodes, :through => :question_conclusions, :as => :global_node
  #def concluding_nodes
  #  Node::QuestionNode.where(:question_id => self.id, :is_conclusion => true)#.collect(&:global_node_id)
    #Node::GlobalNode.where('id IN (?)', gn_ids)
  #end
#whooops! goood! even...
end
