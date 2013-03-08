require "#{Rails.root}/lib/conclusion.rb"

class GroupQuestionConclusion < ActiveRecord::Base
  extend Conclusion

  attr_accessible :global_node_id, :group_id, :question_id

  belongs_to :group
  belongs_to :question
  belongs_to :conclusion, :foreign_key => :global_node_id, :class_name => Node::GlobalNode

  class << self

    private

    def meets_criteria?
      !!@context[:group_id]
    end

    def set_context! context
      context[:group_ids].each do |id|
        context[:group_id] = id
        super
      end
    end

    def search_context
      context = super
      context[:user_id] = Group.find_by_id(context[:group_id]).try(:users).try(:map,&:id)
      context
    end
   
  end
end
