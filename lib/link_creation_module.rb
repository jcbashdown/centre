module LinkCreationModule
  def self.included(base)
  end
 
  def create_appropriate_nodes
    if self.global_node_from_id
      associate_nested_nodes
    else
      create_and_associate_nested_nodes
    end
  end
  
  def create_and_associate_nested_nodes
    self.context_node_from = ContextNode.find_or_create_by_user_id_and_question_id_and_group_id_and_title(:user_id=>self.user_id, :question_id=>self.question_id, :group_id => self.group_id, :title => self.context_node_from_title)
    self.global_node_from_id = self.context_node_from.global_node_id
    associate_nested_nodes
  end  

  def associate_nested_nodes
    self.context_node_from ||= ContextNode.find_or_create_by_user_id_and_question_id_and_group_id_and_title(:user_id=>self.user_id, :question_id=>self.question_id, :group_id => self.group_id, :title => self.global_node_from.title)
    self.context_node_to ||= ContextNode.find_or_create_by_user_id_and_question_id_and_group_id_and_title(:user_id=>self.user_id, :question_id=>self.question_id, :group_id => self.group_id, :title => self.global_node_to.title)
  end
  
  def create_appropriate_links
    self.global_link_id = find_or_create_global_link.id
    @new_links = []
    @existing_links_hash = {}
    new_links_hash = {}
    find_or_initialise_links
    unless @new_links.empty?
      #test this properly - loading right ids?
      #even faster - composite primary key, no need to get back after insert as already know
      Link.import @new_links
      @new_links = synchronize @new_links, Link, [:type, :user_id, :group_id, :global_node_from_id, :global_node_to_id]
      @new_links.each do |link|
        subtype_matcher = /Link::(.*)::#{link_kind}/
        subtype = (subtype_matcher.match(link.type))[1]
        new_links_hash[:"#{subtype.underscore}_id"] = link.id
      end
    end
    attributes = new_links_hash.merge(@existing_links_hash)
    unless user_link_id
      attributes[:user_link_id] = find_or_create_user_link(attributes).id
    end
    self.attributes = attributes
  end

  def find_or_initialise_links
    if (group_ids = self.user.groups.reload.map(&:id)).any?
      group_ids.each do |group_id|
        find_or_initialise("Link::GroupLink::#{link_kind}GroupLink".constantize, {:group_id => group_id, :global_node_from_id => self.global_node_from_id, :global_node_to_id => self.global_node_to_id, :global_link_id => self.global_link_id}, false)
      end
    end
  end  

  def find_or_initialise(the_class, the_params={}, related = true)
    unless link = the_class.where(the_params)[0]
      @new_links << the_class.new(the_params)
    else
      if related
        subtype_matcher = /Link::(.*)::#{link_kind}/
        subtype = (subtype_matcher.match(the_class.to_s))[1]
        @existing_links_hash[:"#{subtype.underscore}_id"] = link.id
      end
    end
  end

  def find_or_create_user_link(attributes)
    params = {:user_id => user_id, :global_node_from_id => self.global_node_from_id, :global_node_to_id => self.global_node_to_id, :global_link_id => self.global_link_id}
    Link::UserLink.where(params)[0] || "Link::UserLink::#{self.link_kind}UserLink".constantize.create!(params)
  end

  def find_or_create_global_link
    params = {:node_from_id => self.global_node_from_id, :node_to_id => self.global_node_to_id}
    link = "Link::GlobalLink::#{self.link_kind}GlobalLink".constantize.where(params)[0] || "Link::GlobalLink::#{self.link_kind}GlobalLink".constantize.create!(params)
  end
end
