require "#{Rails.root}/lib/conclusion.rb"

class GroupQuestionConclusion < ActiveRecord::Base
  extend Conclusion

  attr_accessible :global_node_id, :group_id, :question_id

  belongs_to :group
  belongs_to :question
  belongs_to :conclusion, :foreign_key => :global_node_id, :class_name => Node::GlobalNode

  class << self

    def update_conclusion_status_for context
      if context[:group_ids].any?
        context[:group_ids].each do |id|
          context[:group_id] = id
          super
        end
      else
        super
      end
    end

    private

    def meets_criteria?
      !!@context[:group_id]
    end

    def search_context
      context = super
      context[:user_id] = Group.user_ids_for(context[:group_id])
      context.except :group_id
    end
   
  end
end
