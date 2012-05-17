class GlobalNodeUser < ActiveRecord::Base
  belongs_to :global
  belongs_to :node, :counter_cache => true
  belongs_to :user
  belongs_to :node_user, :counter_cache => true
  belongs_to :global_node, :counter_cache => true

  has_many :global_link_user_ins, :foreign_key => "global_node_user_to_id", :class_name => "GlobalLinkUser"
  has_many :global_link_user_tos, :foreign_key => "global_node_user_from_id", :class_name => "GlobalLinkUser"

  has_many :global_node_user_tos, :through => :global_link_user_tos, :class_name => "GlobalNodeUser", :foreign_key => "global_node_user_to_id", :source=>:global_node_user_to
  has_many :global_node_user_froms, :through => :global_link_user_ins, :class_name => "GlobalNodeUser", :foreign_key => "global_node_user_from_id", :source=>:global_node_user_from
  has_one :positive_node_argument, :as => :subject, :foreign_key => 'subject_id'
  has_one :negative_node_argument, :as => :subject, :foreign_key => 'subject_id'

  after_create :create_node_arguments, :set_or_create_node, :set_or_create_global_node, :set_or_create_node_user
  before_destroy :delete_links_if_allowed
  after_destroy :delete_node_user_if_allowed, :delete_global_node_if_allowed, :delete_node_if_allowed, :destroy_node_arguments

  validates_uniqueness_of :node_id, :scope => [:global_id, :user_id]
  validates_uniqueness_of :title, :scope => [:global_id, :user_id]
  validates :title, :presence => true

  def node_hash
    {:title => self.title, :body => self.body}
  end
  
  def parents(exclude=self)
    array_of_links_arrays = [global_link_user_tos]
    global_node_user_tos.each do |gnu|
      unless gnu == exclude
        array_of_links_arrays << gnu.parents(exclude)
      end
    end
    array_of_links_arrays.flatten.uniq
  end

  def node_argument
    this_negative_node_argument = NegativeNodeArgument.select(:content).where(:subject_id => self.id, :subject_type => 'GlobalNodeUser')[0]
    this_negative_node_argument_doc = Nokogiri::XML(%Q|<negative>|+this_negative_node_argument.content+%Q|</negative>|) do |config|
      config.default_xml.noblanks
    end
    this_negative_node_argument_content = this_negative_node_argument_doc.xpath('/negative').first
    this_positive_node_argument = PositiveNodeArgument.select(:content).where(:subject_id => self.id, :subject_type => 'GlobalNodeUser')[0]
    this_positive_node_argument_doc = Nokogiri::XML(%Q|<positive>|+this_positive_node_argument.content+%Q|</positive>|) do |config|
      config.default_xml.noblanks
    end
    this_positive_node_argument_content = this_positive_node_argument_doc.xpath('/positive').first

    to_doc = Nokogiri::XML(self.to_xml) do |config|
      config.default_xml.noblanks
    end
    to_node = to_doc.xpath('/global-node-user').first
    this_negative_node_argument_content.parent = to_node
    this_positive_node_argument_content.parent = to_node
    to_doc.to_xml
  end
  
  protected
  def create_node_arguments
    PositiveNodeArgument.create(:subject_type => 'GlobalNodeUser', :subject_id => self.id)
    NegativeNodeArgument.create(:subject_type => 'GlobalNodeUser', :subject_id => self.id)
  end

  def destroy_node_arguments
    self.positive_node_argument.destroy
    self.negative_node_argument.destroy
  end

  def set_or_create_node
    n = Node.where(:title => self.title, :body => self.body)[0] || Node.create!(:title => self.title, :body =>self.body)
    self.node = n
    save
  end

  def set_or_create_global_node
    gn = GlobalNode.where(:global_id => self.global_id, :node_id => self.node_id)[0] || GlobalNode.create!({:global_id => self.global_id, :node_id => self.node_id}.merge(node_hash))
    self.global_node = gn
    save
  end

  def set_or_create_node_user
    nu = NodeUser.where(:user_id => self.user_id, :node_id => self.node_id)[0] || NodeUser.create!({:user_id => self.user_id, :node_id => self.node_id}.merge(node_hash))
    self.node_user = nu
    save
  end

  def delete_global_node_if_allowed
    if global_node.reload.global_node_users_count < 1
      global_node.destroy
    end
  end

  def delete_node_user_if_allowed
    if node_user.reload.global_node_users_count < 1
      node_user.destroy
    end
  end

  def delete_node_if_allowed
    if node.reload.global_node_users_count < 1 
      node.destroy
    end
  end

  def delete_links_if_allowed
    self.global_link_user_tos.each do |glut|
      glut.destroy
    end
    self.global_link_user_ins.each do |glui|
      gluf.destroy
    end
  end

end
