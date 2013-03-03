require "#{Rails.root}/lib/conclusion.rb"

class GroupQuestionConclusion < ActiveRecord::Base
  extend Conclusion

  attr_accessible :global_node_id, :group_id, :question_id

  belongs_to :group
  belongs_to :question
  belongs_to :conclusion, :foreign_key => :global_node_id, :class_name => Node::GlobalNode

  class << self

    def update_conclusion_status_for context
      context[:group_ids].each do |id|
        context[:group_id] = id
        super
      end
    end

    def search_context context
      context = super
      context[:user_id] = Group.find(context[:group_id]).users.map(&:id)
      context
    end
   
    def find_or_create_conclusion context
      p context
      super
    end

  end
end
