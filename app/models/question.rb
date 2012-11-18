class Question < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true, :format => { :with => /^((?!all).)*$/i,
    :message => "Please use the pre defined 'All'" }

  def concluding_nodes
    gn_ids = Node::QuestionNode.where(:question_id => self.id, :is_conclusion => true).collect(&:global_node_id)
    Node::GlobalNode.where('id IN (?)', gn_ids)
  end
end
