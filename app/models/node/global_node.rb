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

  #alt would be find all links from ids of nodes, map ids of subset of nodes there are links for
  #from result, delete ids from nodes map and construct for rest, slightly more db efficient as group find?
  def find_view_links_by_context direction, context
    other_node_direction = Link.opposite_direction direction
    nodes = self.class.find_by_context(context.except(:user, :page))
    links = []
    nodes.each do |node|
      unless node == self
        global_link_attrs = {:"global_node_#{direction}_id" => self.id, :"global_node_#{other_node_direction}_id" => node.id}
        link = Link::UserLink.where(global_link_attrs.merge(:user_id => context[:user]))[0].try(:global_link)
        if link
          links << link
        else
          links << Link::GlobalLink.new({:"node_#{direction}_id" => self.id, :"node_#{other_node_direction}_id" => node.id})
        end
      end
    end
    Kaminari.paginate_array(links).page(context[:page]).per(10)
  end

  def global_node
    self
  end

  validates :title, :presence => true
  validates_uniqueness_of :title

  class << self
    def find_by_context conditions
      results = ContextNode.find_by_context(conditions).map(&:global_node_id).uniq 
      if conditions[:page]
        where(:id => results).page(conditions[:page]).per(10)
      else
        where(:id => results)
      end
    end
  end

end
