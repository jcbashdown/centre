require "#{Rails.root}/lib/global_link_mixin.rb"
require "#{Rails.root}/lib/link_user_mixin.rb"
require "#{Rails.root}/lib/link_mixin.rb"

class GlobalLinkUser < ActiveRecord::Base
  include LinkMixin
  include LinkUserMixin
  include GlobalLinkMixin
  belongs_to :global_node_user_from, :class_name => "GlobalNodeUser", :foreign_key=>'global_node_user_from_id', :counter_cache => :global_link_users_count
  belongs_to :global_node_user_to, :class_name => "GlobalNodeUser", :foreign_key=>'global_node_user_to_id', :counter_cache => :global_link_users_count
  belongs_to :node_user_from, :class_name => "NodeUser", :foreign_key=>'node_user_from_id', :counter_cache => :global_link_users_count
  belongs_to :node_user_to, :class_name => "NodeUser", :foreign_key=>'node_user_to_id', :counter_cache => :global_link_users_count

  belongs_to :link_user, :counter_cache => true
  belongs_to :global_link, :counter_cache => true

  after_create :set_or_create_global_node_user_and_node_models, :set_or_create_link, :set_or_create_global_link, :set_or_create_link_user, :update_caches
  after_destroy :delete_link_if_allowed, :delete_global_link_if_allowed, :delete_link_user_if_allowed, :update_caches

  validates_uniqueness_of :user_id, :scope => [:link_id, :global_id]
  validates_uniqueness_of :user_id, :scope => [:node_from_id, :node_to_id, :global_id]

  def link_hash
    {:node_from_id => self.node_from_id, :node_to_id => self.node_to_id, :value =>  self.value}
  end

  def global_link_hash
    {:global_node_from_id => self.global_node_from_id, :global_node_to_id => self.global_node_to_id}
  end

  class << self

    def with_all_associations
      GlobalLinkUser.includes(:global, :link, :user, :global_node_user_from, :global_node_user_to, :node_user_to, :node_user_from, :global_node_to, :global_node_from, :link_user, :global_link)
    end

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
    gl = GlobalLink.where(:global_id => self.global_id, :link_id => self.link_id)[0] || GlobalLink.create({:global_id => self.global_id, :link_id => self.link_id}.merge(self.link_hash).merge(self.global_link_hash))
    self.global_link = gl
    save
    # untested
    old_active_link = GlobalLink.where(:active => true)[0]
    active_link = GlobalLink.where(:global_id => self.global_id, :link_id => self.link_id).order("global_link_users_count desc")[0]
    # need to turn off others
    unless active_link == old_active_link
      active_link.update_attributes(:active => true)
      old_active_link.update_attributes(:active => false)
    end
    # end untested
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

end
