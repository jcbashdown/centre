module Conclusion

  def update_conclusion_status_for global_node, context
    context = attribute_names.inject({}) do |new_context, attr|
      new_context[attr] = context[attr] if context[attr] 
      new_context
    end
    not_conclusion_votes = Node.find_ids_by_context(context.merge({:is_conclusion => false})).count
    is_conclusion_votes = Node.find_ids_by_context(context.merge({:is_conclusion => true})).count
    if is_conclusion_votes > not_conclusion_votes
      find_or_create_conclusion context.merge({:global_node_id => global_node.id})
    else
      destroy_conclusion_if_exists context.merge({:global_node_id => global_node.id})
    end
  end

  def find_or_create_conclusion context
    where(context)[0] || create!(context)
  end

  def destroy_conclusion_if_exists context
    where(context)[0].try(:destroy)
  end
end
