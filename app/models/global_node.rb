require "#{Rails.root}/lib/global_node_mixin.rb"

class GlobalNode < ActiveRecord::Base
  include GlobalNodeMixin
  searchable do
    text :title
    integer :global_id
    integer :id
    double :page_rank
    time :created_at
  end
  belongs_to :node
  has_many :global_node_users

  has_many :global_link_ins, :foreign_key => "global_node_to_id", :class_name => "GlobalLink"
  has_many :global_link_tos, :foreign_key => "global_node_from_id", :class_name => "GlobalLink"
  has_many :positive_global_link_ins, :foreign_key => "global_node_to_id", :class_name => "GlobalLink", :conditions => {:value => 1, :active => true}
  has_many :positive_global_link_tos, :foreign_key => "global_node_from_id", :class_name => "GlobalLink", :conditions => {:value => 1, :active => true}
  has_many :negative_global_link_ins, :foreign_key => "global_node_to_id", :class_name => "GlobalLink", :conditions => {:value => -1, :active => true}
  has_many :negative_global_link_tos, :foreign_key => "global_node_from_id", :class_name => "GlobalLink", :conditions => {:value => -1, :active => true}

  has_many :global_node_tos, :through => :global_link_tos, :class_name => "GlobalNode", :foreign_key => "global_node_to_id", :source=>:global_node_to
  has_many :global_node_froms, :through => :global_link_ins, :class_name => "GlobalNode", :foreign_key => "global_node_from_id", :source=>:global_node_from
  has_many :positive_global_node_tos, :through => :positive_global_link_tos, :class_name => "GlobalNode", :foreign_key => "global_node_to_id", :source=>:global_node_to
  has_many :positive_global_node_froms, :through => :positive_global_link_ins, :class_name => "GlobalNode", :foreign_key => "global_node_from_id", :source=>:global_node_from
  has_many :negative_global_node_tos, :through => :negative_global_link_tos, :class_name => "GlobalNode", :foreign_key => "global_node_to_id", :source=>:global_node_to
  has_many :negative_global_node_froms, :through => :negative_global_link_ins, :class_name => "GlobalNode", :foreign_key => "global_node_from_id", :source=>:global_node_from

  validates :node, :presence => true
  validates :title, :presence => true

  validates_uniqueness_of :node_id, :scope => [:global_id]

end
