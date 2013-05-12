class Question < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true, :format => { :with => /^((?!all).)*$/i,
    :message => "Please use the pre defined 'All'" }

  has_many :question_conclusions
  has_many :concluding_nodes, :through => :question_conclusions, :source => :conclusion

  def argument(context = {})
    context[:question] = self
    concluding_nodes.map do |node|
      node.argument_attributes(context)
    end
  end
end
