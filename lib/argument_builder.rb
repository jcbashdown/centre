module ArgumentBuilder

  def url
    ""
  end

  def argument_attributes(context, parent = nil, depth = {limit:1,current:0})
    argument_user = context[:user]
    argument_question = context[:question]
    support = find_argument_links_by_context("to", {:user_id => argument_user.try(:id), :question_id => argument_question.try(:id)}, type=Link.positive).map(&:global_node_from)
    oppose = find_argument_links_by_context("to", {:user_id => argument_user.try(:id), :question_id => argument_question.try(:id)}, type=Link.negative).map(&:global_node_from)
    new_depth = depth.dup
    new_depth[:current] += 1
    guid = SimpleUUID::UUID.new.to_guid
    {
      guid: guid,
      parent: parent,
      for: (new_depth[:limit] < new_depth[:current] ? [] : support.map {|for_node| for_node.argument_attributes(context, parent.to_s+guid.to_s, new_depth)}),
      against:  (new_depth[:limit] < new_depth[:current] ? [] : oppose.map {|against_node| against_node.argument_attributes(context, parent.to_s+guid.to_s, new_depth)}),
    }.merge(self.attributes)
  end

end
