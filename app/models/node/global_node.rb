class Node::GlobalNode < Node
  has_many :group_question_conclusions
  has_many :user_question_conclusions, :foreign_key => :global_node_id
  has_many :question_conclusions, :foreign_key => :global_node_id

  before_update :set_caches
  after_update :destroy_if_no_users

  def set_caches
    self.users_count = Node::UserNode.count( :conditions => ["global_node_id = ?", self.id] )
  end

  def destroy_if_no_users
    destroy if reload.users_count == 0
  end

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
  def find_view_links_by_context direction, context, type=Link
    nodes = self.class.find_by_context(context.except(:user_id, :page))
    links = send(:"possible_links_#{direction}_of", nodes, context.extract!(:user_id,:group_id), type)
    Kaminari.paginate_array(links).page(context[:page]).per(10)
  end

  [:to, :from].each do |direction|
    define_method :"possible_links_#{direction}_of" do |nodes, context, type=Link|
      other_direction = Link.opposite_direction(direction)
      nodes.inject([]) do |links, node|
        unless node == self
          global_link_attrs = {:"global_node_#{direction}_id" => self.id, :"global_node_#{other_direction}_id" => node.id}
          link = type.where(global_link_attrs.merge(context))[0].try(:global_link)
          if link
            links << link
          else
            links << Link::GlobalLink.new({:"global_node_#{direction}_id" => self.id, :"global_node_#{other_direction}_id" => node.id})
          end
        end
        links
      end
    end
  end

  def find_argument_links_by_context direction, context, type=Link
    nodes = self.class.find_by_context(context.except(:user_id, :page))
    send(:"links_#{direction}_of", nodes, context.extract!(:user_id,:group_id), type)
  end

  [:to, :from].each do |direction|
    define_method :"links_#{direction}_of" do |nodes, context, type=Link|
      other_direction = Link.opposite_direction(direction)
      #also need to do no link link type
      #Make oppsing work, doesn't seem to work for now for sub points, do no link and fill in when no opinion
      global_link_attrs = {:"global_node_#{direction}_id" => self.id, :"global_node_#{other_direction}_id" => (nodes.map {|n| n.id unless n.id == self.id}).compact!}
      type.where(global_link_attrs.merge(context))
    end
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
