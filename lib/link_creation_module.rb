module LinkCreationModule
  def self.included(base)
  end
 
  def create_appropriate_nodes
    ContextNode.find_or_create_by_user_id_and_question_id_and_title(:user_id=>self.user_id, :question_id=>self.question_id, :title => self.global_node_to.title)
    unless self.global_node_from_id
      context_node_from = ContextNode.find_or_create_by_user_id_and_question_id_and_title(:user_id=>self.user_id, :question_id=>self.question_id, :title => self.context_node_from_title)
      self.global_node_from_id = context_node_from.global_node_id
    else
      ContextNode.find_or_create_by_user_id_and_question_id_and_title(:user_id=>self.user_id, :question_id=>self.question_id, :title => self.global_node_from.title)
    end
    self
  end

  def create_appropriate_links
    self.global_link_id = find_or_create_global_link.id
    find_or_create_group_links
    self
  end

  def find_or_create_group_links
    if (group_ids = self.user.groups.reload.map(&:id)).any?
      group_ids.inject([]) do |group_links, group_id|
        group_links << find_or_create_group_link("Link::GroupLink::#{link_kind}GroupLink".constantize, {:group_id => group_id, :global_node_from_id => self.global_node_from_id, :global_node_to_id => self.global_node_to_id, :global_link_id => self.global_link_id})
        group_links
      end
      group_links
    else
      []
    end
  end 

  def find_or_create_group_link(the_class, the_params={})
    the_class.where(the_params)[0] || the_class.create!(the_params)
  end

  def find_or_create_global_link
    params = {:global_node_from_id => self.global_node_from_id, :global_node_to_id => self.global_node_to_id}
    link = "Link::GlobalLink::#{self.link_kind}GlobalLink".constantize.where(params)[0] || "Link::GlobalLink::#{self.link_kind}GlobalLink".constantize.create!(params)
  end
end
