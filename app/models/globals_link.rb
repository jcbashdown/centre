class GlobalsLink < ActiveRecord::Base
  belongs_to :link
  belongs_to :global

  after_save :update_node_to_xml, :update_global_xml
#store on the nodes global. votes on nodes global
  def update_node_to_xml
    node = link.node_to
    votes_xml = "<node_froms type='array'>"
    node.node_froms.reload.each do |from|
      p 123
      p from
      p from.nodes_globals
      p global.id
      p 123
      #unless they're in the global ignore?
      votes_xml+=from.nodes_globals.where(:global_id=>global.id).first.votes_xml
    end
    votes_xml = votes_xml+"</node_froms>"
    nodes_global = node.nodes_globals.where(:global_id=>global.id).first
    p nodes_global
    nodes_global.votes_xml = votes_xml
    nodes_global.save!
    #node xmls
    #node to id
    
    
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
