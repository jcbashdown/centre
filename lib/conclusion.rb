module Conclusion

  def search_context context
    HashWithIndifferentAccess.new self.create_context(context)
  end

  def create_context context
    context = attribute_names.inject({}) do |new_context, attr|
      new_context[attr] = context[attr] if context[attr] 
      new_context
    end
    HashWithIndifferentAccess.new context
  end

  def update_conclusion_status_for context
    #binding.pry if self == GroupQuestionConclusion
    not_conclusion_votes = ContextNode.where(self.search_context(context).merge({:is_conclusion => false})).count
    is_conclusion_votes = ContextNode.where(self.search_context(context).merge({:is_conclusion => true})).count
    if is_conclusion_votes > not_conclusion_votes
      find_or_create_conclusion self.create_context(context)
    else
      destroy_conclusion_if_exists self.create_context(context)
    end
  end

  def find_or_create_conclusion context
    where(context)[0] || create!(context)
  end

  def destroy_conclusion_if_exists context
    where(context)[0].try(:destroy)
  end
end
