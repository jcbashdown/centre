class Node::UserNode
  attr_accessor :question_id 
  attr_accessor :question

  belongs_to :global_node, :class_name => Node::GlobalNode
  belongs_to :user

  validates_presence_of :global_node
  validates_presence_of :user

  def question
    @question ||= Question.find_by_id question_id
  end

  def question_id
    @question_id ||= @question.try(:id)
  end

  class << self
    [:create, :create!].each do |method|
      define_method method do |attributes = {}|
        ActiveRecord::Base.transaction do
          new_user_node = self.new(attributes)
          new_user_node.create_context_node_if_needed
          new_user_node.save if method == :create
          new_user_node.save! if method == :create!
          new_user_node
        end
      end
    end
  end

  def create_context_node_if_needed
    context_node = ContextNode.where(context)[0] || ContextNode.create(context)
    self.global_node_id = context_node.global_node_id
  end

  def context
    HashWithIndifferentAccess.new({:question_id => self.question_id, :user_id => self.user_id, :title=> self.title})
  end
end
