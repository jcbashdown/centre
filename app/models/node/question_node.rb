class Node::QuestionNode < Node
  belongs_to :global_node

  has_many :positive_link_froms, :foreign_key => "node_to_id", :class_name => "Link::QuestionLink::PositiveQuestionLink", :conditions => {:active => true}
  has_many :positive_link_tos, :foreign_key => "node_from_id", :class_name => "Link::QuestionLink::PositiveQuestionLink", :conditions => {:active => true}
  has_many :negative_link_froms, :foreign_key => "node_to_id", :class_name => "Link::QuestionLink::PositiveQuestionLink", :conditions => {:active => true}
  has_many :negative_link_tos, :foreign_key => "node_from_id", :class_name => "Link::QuestionLink::PositiveQuestionLink", :conditions => {:active => true}

  has_many :positive_node_tos, :through => :positive_link_tos, :class_name => "Node::QuestionNode", :foreign_key => "node_to_id", :source=>:question_node_to
  has_many :positive_node_froms, :through => :positive_link_froms, :class_name => "Node::QuestionNode", :foreign_key => "node_from_id", :source=>:question_node_from
  has_many :negative_node_tos, :through => :negative_link_tos, :class_name => "Node::QuestionNode", :foreign_key => "node_to_id", :source=>:question_node_to
  has_many :negative_node_froms, :through => :negative_link_froms, :class_name => "Node::QuestionNode", :foreign_key => "node_from_id", :source=>:question_node_from

  searchable do
    text :title
    integer :id
    integer :question_id
  end
end
