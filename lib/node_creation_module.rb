module NodeCreationModule
  def self.included(base)
  end
  
  def create_appropriate_nodes
    @new_nodes = []
    @existing_nodes_hash = {}
    title_hash = {}
    title_hash[:node_title_id] = find_or_create_node_title.id
    find_or_create_nodes
    #unless @new_nodes.empty?
      #this is nice but sort of pointless for now
      #Node.import @new_nodes
      #new_nodes_hash = {}
      #@new_nodes.each do |node|
        #getting the id here doesn't work
        #new_nodes_hash[:"#{node.type.underscore}_id"] = node.reload.id
      #end
    #end
    attributes = new_nodes_hash.merge(@existing_nodes_hash).merge(title_hash)
  end

  def find_or_create_node_title
    NodeTitle.where(:title => title)[0] || NodeTitle.create!(:title => title)
  end

  def find_or_create_nodes
    find_or_create(Node::GlobalNode)
    find_or_create(Node::UserNode, {:user_id => user_id})
    if question
      find_or_create(Node::QuestionNode, {:question_id => question_id})
    end
  end  

  def find_or_create(the_class, the_params={})
    #redundant without import
    #unless node = the_class.where({:node_title_id => node_title_id}.merge(the_params))[0]
    #  @new_nodes << the_class.new({:node_title_id => node_title_id, :title => title, :is_conclusion => is_conclusion}.merge(the_params))
    #else
      #to do conclusion we need to update all where it changes in one go - need to use similar to new nodes?
      #@existing_nodes_hash[:"#{the_class.to_s.underscore}_id"] = node.id
    #end
    @existing_nodes_hash[:"#{the_class.to_s.underscore}_id"] = the_class.where({:node_title_id => node_title_id}.merge(the_params))[0].try(:id) || the_class.create!({:node_title_id => node_title_id, :title => title, :is_conclusion => is_conclusion}.merge(the_params)).id
  end

end

