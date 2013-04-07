class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me

  has_many :context_nodes
  [:positive, :negative].each do |type|
    has_many :"#{type}_user_links", :class_name => "Link::UserLink::#{type.capitalize}UserLink".constantize
    has_many :"#{type}_global_links", :through => :"#{type}_user_links"
  end

  def user_links
    Link::UserLink.where(:user_id => self.id)
  end

  def global_links
    Link::GlobalLink.where(:id => user_links.pluck(:global_link_id))
  end

  has_many :user_groups
  has_many :groups, :through => :user_groups

  has_many :user_question_conclusions
  has_many :conclusions, :through => :user_question_conclusions

  def concluding_nodes(question)
    conclusions.by_question_for_user(question)
  end

  def may_destroy(question)
    ContextNode.where("user_id != #{self.id}").where(:question_id => question.id).count == 0
  end
end
