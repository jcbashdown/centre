class GlobalLinkUser < ActiveRecord::Base
  belongs_to :node_from, :class_name => "Node", :foreign_key=>'node_from_id'
  belongs_to :node_to, :class_name => "Node", :foreign_key=>'node_to_id'
  belongs_to :global_node_user_from, :class_name => "GlobalNodeUser", :foreign_key=>'global_node_user_from_id', :counter_cache => :global_link_users_count
  belongs_to :global_node_user_to, :class_name => "GlobalNodeUser", :foreign_key=>'global_node_user_to_id', :counter_cache => :global_link_users_count
  belongs_to :global_node_from, :class_name => "GlobalNode", :foreign_key=>'global_node_from_id', :counter_cache => :global_link_users_count
  belongs_to :global_node_to, :class_name => "GlobalNode", :foreign_key=>'global_node_to_id', :counter_cache => :global_link_users_count
  belongs_to :node_user_from, :class_name => "NodeUser", :foreign_key=>'node_user_from_id', :counter_cache => :global_link_users_count
  belongs_to :node_user_to, :class_name => "NodeUser", :foreign_key=>'node_user_to_id', :counter_cache => :global_link_users_count

  belongs_to :global
  belongs_to :link, :counter_cache => true
  belongs_to :user
  belongs_to :link_user, :counter_cache => true
  belongs_to :global_link, :counter_cache => true

  #validates :node_from, :presence => true
  #validates :node_to, :presence => true
  #after_save :update_caches
  after_create :set_or_create_link, :set_or_create_global_link, :set_or_create_link_user, :set_or_create_global_node_user_and_node_models, :update_caches, :update_node_to_xml
  after_destroy :delete_link_if_allowed, :delete_global_link_if_allowed, :delete_link_user_if_allowed, :update_caches#update xml

  validates_uniqueness_of :user_id, :scope => [:link_id, :global_id]
  validates_uniqueness_of :user_id, :scope => [:node_from_id, :node_to_id, :global_id]

  def link_hash
    {:node_from_id => self.node_from_id, :node_to_id => self.node_to_id, :value =>  self.value}
  end
  
  protected
  def set_or_create_link
    l = Link.where(self.link_hash)[0] || Link.create(self.link_hash)
    self.link = l
    save
  end

  def vote_type
    if value == 1
      :upvotes_count
    elsif value == -1
      :downvotes_count
    else
      :equivalents_count
    end
  end

  def set_or_create_global_link
    gl = GlobalLink.where(:global_id => self.global_id, :link_id => self.link_id)[0] || GlobalLink.create({:global_id => self.global_id, :link_id => self.link_id}.merge(self.link_hash))
    self.global_link = gl
    save
  end

  def set_or_create_link_user
    lu = LinkUser.where(:user_id => self.user_id, :link_id => self.link_id)[0] || LinkUser.create({:user_id => self.user_id, :link_id => self.link_id}.merge(self.link_hash))
    self.link_user = lu
    save
  end
  
  def set_or_create_global_node_user_and_node_models
    @gnu_from_hash = {:global_id => self.global_id, :node_id => self.node_to_id, :user_id => self.user_id}
    @gnu_from_hash_with_title_text = @gnu_from_hash.merge(self.node_to.node_hash)
    gnu_to = GlobalNodeUser.where(@gnu_from_hash)[0] || GlobalNodeUser.create(@gnu_from_hash_with_title_text)
    self.global_node_user_to = gnu_to
    @gnu_from_hash = {:global_id => self.global_id, :node_id => self.node_from_id, :user_id => self.user_id}
    @gnu_from_hash_with_title_text = @gnu_from_hash.merge(self.node_from.node_hash)
    gnu_from = GlobalNodeUser.where(@gnu_from_hash)[0] || GlobalNodeUser.create(@gnu_from_hash_with_title_text)
    self.global_node_user_from = gnu_from

    nu_to = NodeUser.where(:node_id => self.node_to_id, :user_id => self.user_id)[0]
    self.node_user_to = nu_to
    nu_from = NodeUser.where(:node_id => self.node_from_id, :user_id => self.user_id)[0]
    self.node_user_from = nu_from

    gn_to = GlobalNode.where(:global_id => self.global_id, :node_id => self.node_to_id)[0]
    self.global_node_to = gn_to
    gn_from = GlobalNode.where(:global_id => self.global_id, :node_id => self.node_from_id)[0]
    self.global_node_from = gn_from

    save
  end

  def delete_link_if_allowed
    # less than one because after destroy
    if self.link.reload.global_link_users_count < 1
      link.destroy
    end
  end

  def delete_global_link_if_allowed
    # less than one because after destroy
    if self.global_link.reload.global_link_users_count < 1
      global_link.destroy
    end
  end

  def delete_link_user_if_allowed
    # less than one because after destroy
    if self.link_user.reload.global_link_users_count < 1
      link_user.destroy
    end
  end

  def update_caches
    this_node_to = Node.find(self.node_to_id) 
    this_node_from = Node.find(self.node_from_id)
    this_node_to.update_attributes!(:upvotes_count => LinkUser.count( :conditions => ["value = 1 AND node_to_id = ?",self.node_to_id]))
    this_node_to.update_attributes!(:downvotes_count => LinkUser.count( :conditions => ["value = -1 AND node_to_id = ?",self.node_to_id]))
    this_node_to.update_attributes!(:equivalents_count => LinkUser.count( :conditions => ["value = 0 AND node_to_id = ?",self.node_to_id]))
    this_node_from.update_attributes!(:equivalents_count => LinkUser.count( :conditions => ["value = 0 AND node_from_id = ?",self.node_from_id]))

    if self.global_node_user_to_id && self.global_node_user_from_id
      this_gnu_to = GlobalNodeUser.find(self.global_node_user_to_id) 
      this_gnu_from = GlobalNodeUser.find(self.global_node_user_from_id)
      if self.persisted?
        this_value = 1
      else
        this_value = 0
      end
      if self.value == 0
        this_gnu_to.update_attributes!(vote_type => this_value) 
        this_gnu_from.update_attributes!(vote_type => this_value) 
      else
        this_gnu_to.update_attributes!(vote_type => this_value) 
      end
    end

    if self.global_node_to_id && self.global_node_from_id
      this_gn_to = GlobalNode.find(self.global_node_to_id) 
      this_gn_from = GlobalNode.find(self.global_node_from_id)
      this_gn_to.update_attributes!(:upvotes_count => GlobalLinkUser.count( :conditions => ["value = 1 AND global_node_to_id = ?",self.global_node_to_id]))
      this_gn_to.update_attributes!(:downvotes_count => GlobalLinkUser.count( :conditions => ["value = -1 AND global_node_to_id = ?",self.global_node_to_id]))
      this_gn_to.update_attributes!(:equivalents_count => GlobalLinkUser.count( :conditions => ["value = 0 AND global_node_to_id = ?",self.global_node_to_id]))
      this_gn_from.update_attributes!(:equivalents_count => GlobalLinkUser.count( :conditions => ["value = 0 AND global_node_from_id = ?",self.global_node_from_id]))
    end

    if self.node_user_to_id && self.node_user_from_id
      this_nu_to = NodeUser.find(self.node_user_to_id) 
      this_nu_from = NodeUser.find(self.node_user_from_id)
      if self.link_user.persisted?
        this_value = 1
      else
        this_value = 0
      end
      if self.value == 0
        this_nu_to.update_attributes!(vote_type => this_value) 
        this_nu_from.update_attributes!(vote_type => this_value) 
      else
        this_nu_to.update_attributes!(vote_type => this_value) 
      end
    end
  end

  def update_node_to_xml
    update_global_node_user_to_xml
    update_global_node_to_xml
  end

  def update_global_node_user_to_xml
    if self.value == 1
      node_argument = global_node_user_to.positive_node_argument
    elsif self.value == -1
      node_argument = global_node_user_to.negative_node_argument
    else
      return
    end
    #remove looping references
    new_argument_doc = Nokogiri::XML(global_node_user_from.node_argument) {|config| config.default_xml.noblanks}
    new_argument_doc.xpath("//id[text()='#{global_node_user_to.id}']").each {|node| node.parent.remove}
    new_argument = new_argument_doc.to_xml(:indent=>2).gsub(%Q|<?xml version="1.0" encoding="UTF-8"?>\n|, "")
    new_content = node_argument.content+new_argument
    node_argument.update_attributes!(:content => new_content)
    #delete? change existing?
=begin
      AFTER ALL THIS

      update node args of any nodes this links to
      they will do above
      and update their parents
      
      AFTER ALL THIS 

      if is conclusion then do whole arg update with this conclusion block (reset to this node tos new from and to args
=end
  end
  
  def update_global_node_to_xml

  end

end
