class GlobalsLink < ActiveRecord::Base
  belongs_to :link
  belongs_to :global
  
  has_many :user_globals_link
  has_many :users, :through=>:user_globals_link

  after_save :update_node_to_xml, :update_global_xml
  #after_save :change_counter_cache, :turn_off_node_ignore
  #after_destroy :decrement_counter_cache, :turn_on_node_ignore
  
  def turn_off_node_ignore
    nodes_global_to = link.nodes_global_to
    nodes_global_from = link.nodes_global_from
    unless link.value == 0 || link.value.blank?
      nodes_global_to.update_attributes(:ignore=>false)
      nodes_global_from.update_attributes(:ignore=>false)
    end
  end  
  def turn_on_node_ignore
    unless link.value == 0 || link.value.blank?
      if !nodes_global_to.has_links?
        nodes_global_to.update_attributes(:ignore=>true)
      elsif !nodes_global_from.has_links?
        nodes_global_from.update_attributes(:ignore=>true)
      end
    end
  end  

  def change_counter_cache
    nodes_global = link.nodes_global_to
    nodes_global.upvotes_count = nodes_global.sum_votes(1)
    nodes_global.downvotes_count = nodes_global.sum_votes(-1)
    nodes_global.equivalents_count = nodes_global.sum_votes(0)
    nodes_global.save!
  end
  
  def decrement_counter_cache
    vote = link.value
    nodes_global = link.nodes_global_to
    if vote == 1
      nodes_global.upvotes_count-=users_count
    elsif vote == -1
      nodes_global.downvotes_count-=users_count
    else
      nodes_global.equivalents_count-=users_count
    end
    nodes_global.save!
  end
  
  def update_node_to_xml
#    #for node global positive minus neg
#    #else use vote
#    node = link.nodes_global_to
#    votes_xml = "<node_froms type='array'>"
#    node.nodes_global_froms.reload.each do |from|
#      #unless they're in the global ignore
#      vote_xml = from.votes_xml
#      if vote_xml
#        #delete this node and below if present
#        votes_xml+= vote_xml
#      end
#    end
#    votes_xml = votes_xml+"</node_froms>"
#    froms_doc = Nokogiri::XML(votes_xml) do |config|
#      config.default_xml.noblanks
#    end
#    node_xml = node.to_xml
#    to_doc = Nokogiri::XML(node_xml) do |config|
#      config.default_xml.noblanks
#    end
#    from_nodes = froms_doc.xpath('/node_froms').first
#    to_node = to_doc.xpath('/node').first
#    from_nodes.parent = to_node
#    nodes_global.votes_xml = to_doc.to_xml(:indent=>2).gsub(%Q|<?xml version="1.0" encoding="UTF-8"?>\n|, "")
#    nodes_global.save!
#    #do up until this node
  end

  def update_node_to_parent_xml
    #actually do this on node to - if the xml is changing also update the parent and this should cascade
  end

  def update_global_xml
    #if link.node_to.is_conclusion
      #find conclusion and update to votes chain up until this conclusion
      #else
      #create conclusion and to votes chain so far until this conclusion
    #end
    #if node_from.title already present
    #replace node from title and sub nodes to conlusion
    #else
    #link.node_from.node_tos.each do |node_to|
      #if node to text present add in this as one sub for each
    #end
  end


end
