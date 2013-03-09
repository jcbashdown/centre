class Node::GlobalNode < Node
  has_many :group_question_conclusions
  has_many :user_question_conclusions, :foreign_key => :global_node_id
  has_many :question_conclusions, :foreign_key => :global_node_id

  scope :by_question_for_group, lambda {|question|
    unless question.nil?
      joins(:group_question_conclusions).
      where('group_question_conclusions.question_id = ?', question.id)
    end
  }
  scope :by_question_for_user, lambda {|question|
    unless question.nil?
      joins(:user_question_conclusions).
      where('user_question_conclusions.question_id = ?', question.id)
    end
  }

  searchable do
    text :title
    integer :id
  end
  def global_node
    self
  end

  validates :title, :presence => true
  validates_uniqueness_of :title

end
