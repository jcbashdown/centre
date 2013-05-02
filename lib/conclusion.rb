module Conclusion

  def update_conclusion_status_for context
    set_context! context
    return unless meets_criteria?
    if votes_for_conclusion > votes_against_conclusion
      create_conclusion_unless_exists create_context
    else
      destroy_conclusion_if_exists create_context
    end
  end
  
  private

  def meets_criteria?
    true
  end

  def search_context
    HashWithIndifferentAccess.new create_context.merge(:user_nodes => {:global_node_id => @context[:global_node_id]}).except("global_node_id")
  end

  def create_context
    create_context = attribute_names.inject({}) do |new_context, attr|
      new_context[attr] = @context[attr] if @context[attr] 
      new_context
    end
  end

  def set_context! context
    @context = context
  end

  def votes_for_conclusion
    vote_count true
  end

  def votes_against_conclusion
    vote_count false
  end

  def vote_count conclusion_status
    ContextNode.joins(:user_node).includes(:user_node).where(search_context.merge({:is_conclusion => conclusion_status})).count
  end

  def create_conclusion_unless_exists create_context
    exists?(create_context) || create!(create_context)
  end

  def destroy_conclusion_if_exists create_context
    where(create_context)[0].try(:destroy)
  end
end