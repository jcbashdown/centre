class GlobalsLink < ActiveRecord::Base
  belongs_to :link
  belongs_to :global

  after_save :update_node_to_xml, :update_global_xml
#store on the nodes global. votes on nodes global
  def update_node_to_xml
    node = link.node_to
    nodes_global = node.nodes_globals.where(:global_id=>global.id).first
    votes_xml = "<node_froms type='array'>"
    node.node_froms.reload.each do |from|
      #unless they're in the global ignore?
      vote_xml = from.nodes_globals.where(:global_id=>global.id).first.try(:votes_xml)
      if vote_xml
        votes_xml+= vote_xml
      end
    end
    votes_xml = votes_xml+"</node_froms>"
    froms_doc = Nokogiri::XML(votes_xml) do |config|
      config.default_xml.noblanks
    end
    node_xml = node.to_xml
    to_doc = Nokogiri::XML(node_xml) do |config|
      config.default_xml.noblanks
    end
    from_nodes = froms_doc.xpath('/node_froms').first
    to_node = to_doc.xpath('/node').first
    from_nodes.parent = to_node
    nodes_global.votes_xml = to_doc.to_xml(:indent=>2).gsub(%Q|<?xml version="1.0" encoding="UTF-8"?>\n|, "")
    nodes_global.save!
    #do up until conclusions
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
