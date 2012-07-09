module LinkCreationModule
  def self.included(base)
  end
 
  def create_appropriate_nodes
    self.global_node_from = GlobalNode.find self.global_node_from_id
    self.global_node_to = GlobalNode.find self.global_node_to_id
    self.context_node_from = ContextNode.create(:user=>self.user, :question=>self.question, :title => self.global_node_from.title)
    self.context_node_to = ContextNode.create(:user=>self.user, :question=>self.question, :title => self.global_node_to.title)
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
        new_links_hash[:"#{link.type.gsub("Link::", "").underscore}_id"] = link.id
      end
    end
    self.attributes = new_links_hash.merge(@existing_links_hash)
  end

  def find_or_initialise_links
    find_or_initialise("Link::GlobalLink::#{self.link_kind}GlobalLink".constantize, {:global_node_from_id => self.global_node_from_id, :global_node_to_id => self.global_node_to_id})
    find_or_initialise("Link::UserLink::#{self.link_kind}UserLink".constantize, {:user_id => user_id, :user_node_from_id => self.user_node_from_id, :user_node_to_id => self.user_node_to_id})
    if question
      find_or_initialise("Link::QuestionLink::#{link_kind}QuestionLink".constantize, {:question_id => question_id, :question_node_from_id => self.question_node_from_id, :question_node_to_id => self.question_node_to_id})
    end
  end  

  def find_or_initialise(the_class, the_params={})
    unless link = the_class.where(the_params)[0]
      @new_links << the_class.new(the_params)
    else
      subtype_matcher = /Link::(.*)::#{node_type}/
      subtype = (subtype_matcher.match(the_class.to_s))[0]
      @existing_links_hash[:"#{subtype.underscore}_id"] = link.id
    end
  end
end
