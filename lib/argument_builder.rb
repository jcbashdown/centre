module ArgumentBuilder

  def url
    ""
  end

  def argument_attributes(context, parent = [], depth = {limit:1,current:0})
    argument_user = context[:user]
    argument_question = context[:question]
    support = find_argument_links_by_context("to", {:user_id => argument_user.try(:id), :question_id => argument_question.try(:id)}, type=Link.positive).map(&:global_node_from)
    oppose = find_argument_links_by_context("to", {:user_id => argument_user.try(:id), :question_id => argument_question.try(:id)}, type=Link.negative).map(&:global_node_from)
    new_depth = depth.dup
    new_depth[:current] += 1
    guid = SimpleUUID::UUID.new.to_guid
    new_parent = parent.last.to_i == id ? parent : parent + [id.to_s]
    {
      guid: guid,
      parent: new_parent, 
      for: (new_depth[:limit] < new_depth[:current] ? [] : support.map {|for_node| for_node.argument_attributes(context, new_parent, new_depth)}),
      against:  (new_depth[:limit] < new_depth[:current] ? [] : oppose.map {|against_node| against_node.argument_attributes(context, new_parent, new_depth)}),
    }.merge(self.attributes)
  end

end
