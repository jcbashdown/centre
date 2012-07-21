module LinkCreationModule
  def self.included(base)
  end
 
  def create_appropriate_nodes
    self.global_node_from = Node::GlobalNode.find self.global_node_from_id
    self.global_node_to = Node::GlobalNode.find self.global_node_to_id
    self.context_node_from = ContextNode.find_or_create_by_user_id_and_question_id_and_title(:user_id=>self.user.id, :question_id=>self.question.id, :title => self.global_node_from.title)
    self.context_node_to = ContextNode.find_or_create_by_user_id_and_question_id_and_title(:user_id=>self.user.id, :question_id=>self.question.id, :title => self.global_node_to.title)
    self.user_node_from = self.context_node_from.user_node
    self.user_node_to = self.context_node_to.user_node
    self.question_node_from = self.context_node_from.question_node
    self.question_node_to = self.context_node_to.question_node
  end
  
  def create_appropriate_links
    @new_links = []
    @existing_links_hash = {}
    new_links_hash = {}
    find_or_initialise_links
    unless @new_links.empty?
      #test this properly - loading right ids?
      #even faster - composite primary key, no need to get back after insert as already know
      Link.import @new_links
      @new_links = synchronize @new_links, Link, [:type, :user_id, :question_id, :node_from_id, :node_to_id]
      @new_links.each do |link|
        subtype_matcher = /Link::(.*)::#{link_kind}/
        subtype = (subtype_matcher.match(link.type))[1]
        new_links_hash[:"#{subtype.underscore}_id"] = link.id
      end
    end
    attributes = new_links_hash.merge(@existing_links_hash)
    attributes[:user_link_id] = find_or_create_user_link.id
    self.attributes = attributes
  end

  def find_or_initialise_links
    find_or_initialise("Link::GlobalLink::#{self.link_kind}GlobalLink".constantize, {:node_from_id => self.global_node_from_id, :node_to_id => self.global_node_to_id})
    if question
      find_or_initialise("Link::QuestionLink::#{link_kind}QuestionLink".constantize, {:question_id => question_id, :node_from_id => self.question_node_from_id, :node_to_id => self.question_node_to_id})
    end
  end  

  def find_or_initialise(the_class, the_params={})
    unless link = the_class.where(the_params)[0]
      @new_links << the_class.new(the_params)
    else
      subtype_matcher = /Link::(.*)::#{link_kind}/
      subtype = (subtype_matcher.match(the_class.to_s))[1]
      @existing_links_hash[:"#{subtype.underscore}_id"] = link.id
    end
  end

  def find_or_create_user_link
    "Link::UserLink::#{self.link_kind}UserLink".constantize.where({:user_id => user_id, :node_from_id => self.user_node_from_id, :node_to_id => self.user_node_to_id})[0] || "Link::UserLink::#{self.link_kind}UserLink".constantize.create!({:user_id => user_id, :node_from_id => self.user_node_from_id, :node_to_id => self.user_node_to_id, :global_node_from_id => self.global_node_from_id, :global_node_to_id => self.global_node_to_id, :global_link_id => attributes[:global_link_id]})
  end
end
