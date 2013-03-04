module Conclusion

  def update_conclusion_status_for context
    set_context! context
    if votes_for_conclusion > votes_against_conclusion
      find_or_create_conclusion create_context
    else
      destroy_conclusion_if_exists create_context
    end
  end
  
  private

  def search_context
    HashWithIndifferentAccess.new create_context
  end

  def create_context
    create_context = attribute_names.inject({}) do |new_context, attr|
      new_context[attr] = @context[attr] if @context[attr] 
      new_context
    end
    HashWithIndifferentAccess.new create_context
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
    ContextNode.where(search_context.merge({:is_conclusion => conclusion_status})).count
  end

  def find_or_create_conclusion create_context
    where(create_context)[0] || create!(create_context)
  end

  def destroy_conclusion_if_exists create_context
    where(create_context)[0].try(:destroy)
  end
end
