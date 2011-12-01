class Node < ActiveRecord::Base
  validates :title, :presence => true
  has_many :link_ins, :foreign_key => "node_to", :class_name => "Link"
  has_many :link_tos, :foreign_key => "node_from", :class_name => "Link"
  has_many :target_nodes, :through => :link_tos, :class_name => "Node", :foreign_key => "node_from"
  has_many :source_nodes, :through => :link_ins, :class_name => "Node", :foreign_key => "node_to"
  
  accepts_nested_attributes_for :link_ins, :link_tos, :reject_if => :reject_link
  #has_many :related_nodes, :through => :links
  #spec this - has many so this is wrong approach?
  def reject_link(hash)
    hash.each do |key|
      unless key=='user_id'
        return hash[key].blank?
      end
    end 
  end
  
end
