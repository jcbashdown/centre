class Group < ActiveRecord::Base
  attr_accessible :about, :title

  has_many :user_groups
  has_many :users, :through => :user_groups

  has_many :group_question_conclusions
  has_many :conclusions, :through => :group_question_conclusions

  [:positive, :negative].each do |type|
    has_many :"#{type}_group_links", :class_name => "Link::GroupLink::#{type.capitalize}GroupLink".constantize
    has_many :"#{type}_global_links", :through => :"#{type}_group_links"
  end

  def group_links
    Link::GroupLink.where(:group_id => self.id)
  end

  def global_links
    Link::GlobalLink.where(:id => group_links.pluck(:global_link_id))
  end

  def concluding_nodes(question)
    conclusions.by_question_for_group(question)
  end

  def user_ids
    users.map(&:id)
  end

  class << self
    def user_ids_for id
      Group.find(id).user_ids
    end
  end
    
end
