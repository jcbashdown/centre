module Conclusion

  def update_conclusion_status_for context
    set_context! context
    p @context
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
    x = HashWithIndifferentAccess.new create_context
    p x
    x
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
    x = vote_count true
    p self
    p x if self == GroupQuestionConclusion
    x
  end

  def votes_against_conclusion
    x = vote_count false
    p self
    p x if self == GroupQuestionConclusion
    x
  end

  def vote_count conclusion_status
    p "search" if self == GroupQuestionConclusion
    p search_context if self == GroupQuestionConclusion
    p "search" if self == GroupQuestionConclusion
    ContextNode.where(search_context.merge({:is_conclusion => conclusion_status})).count
  end

  def create_conclusion_unless_exists create_context
    p 111
    p "create"
    p create_context
    unless exists?(create_context) 
      p "actual create"
      p cn = create_context
      create!(cn)
    end
  end

  def destroy_conclusion_if_exists create_context
    p 222
    where(create_context)[0].try(:destroy)
  end
end
