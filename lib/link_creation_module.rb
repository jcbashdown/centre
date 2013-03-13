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
    unless user_link_id
      attributes[:user_link_id] = find_or_create_user_link(attributes).id
    end
    find_or_create_links
    self.attributes = attributes
  end

  def find_or_create_links
    if (group_ids = self.user.groups.reload.map(&:id)).any?
      group_ids.each do |group_id|
        find_or_create_group_link("Link::GroupLink::#{link_kind}GroupLink".constantize, {:group_id => group_id, :global_node_from_id => self.global_node_from_id, :global_node_to_id => self.global_node_to_id, :global_link_id => self.global_link_id})
      end
    end
  end 

  def find_or_create_group_link(the_class, the_params={})
    unless the_class.where(the_params)[0]
      the_class.create!(the_params)
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
