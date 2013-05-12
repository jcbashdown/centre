module ArgumentBuilder

  def url
    ""
  end

  def argument_attributes(context, depth = {limit:1,current:0})
    argument_user = context[:user]
    argument_question = context[:question]
    support = find_argument_links_by_context("to", {:user_id => argument_user.try(:id), :question_id => argument_question.try(:id)}, type=Link.positive).map(&:global_node_from)
    oppose = find_argument_links_by_context("to", {:user_id => argument_user.try(:id), :question_id => argument_question.try(:id)}, type=Link.negative).map(&:global_node_from)
    depth[:current] += 1
    {
      for: (depth[:limit] < depth[:current] ? [] : support.map {|for_node| for_node.argument_attributes(context, depth)}),
      against:  (depth[:limit] < depth[:current] ? [] : oppose.map {|against_node| against_node.argument_attributes(context, depth)}),
    }.merge(self.attributes)
  end

end
