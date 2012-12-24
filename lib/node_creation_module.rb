module NodeCreationModule
  def self.included(base)
  end
  
  def create_appropriate_nodes
    @new_nodes = []
    @existing_nodes_hash = {}
    new_nodes_hash = {}
    global_node = find_or_create_global_node
    @existing_nodes_hash[:global_node_id] = global_node.id
    find_or_initialise_nodes global_node.id
    unless @new_nodes.empty?
      #test this properly - loading right ids?
      #even faster - composite primary key, no need to get back after insert as already know
      Node.import @new_nodes
      @new_nodes = synchronize @new_nodes, Node, [:type, :user_id, :question_id, :global_node_id]
      @new_nodes.each do |node|
        new_nodes_hash[:"#{node.type.gsub("Node::", "").underscore}_id"] = node.id
      end
    end
    self.attributes = new_nodes_hash.merge(@existing_nodes_hash)
  end

  def find_or_initialise_nodes(global_node_id)
    find_or_initialise(Node::UserNode, {:user_id => user_id, :global_node_id => global_node_id})
    if question
      find_or_initialise(Node::QuestionNode, {:question_id => question_id, :global_node_id => global_node_id})
    end
  end  

  def find_or_initialise(the_class, the_params={})
    unless node = the_class.where(the_params)[0]
      @new_nodes << the_class.new({:title => title, :is_conclusion => is_conclusion}.merge(the_params))
    else
      #to do conclusion we need to update all where it changes in one go - need to use similar to new nodes?
      @existing_nodes_hash[:"#{the_class.to_s.gsub("Node::", "").underscore}_id"] = node.id
    end
  end

  def find_or_create_global_node
    Node::GlobalNode.where(:title => self.title)[0] || Node::GlobalNode.create({:title => self.title, :is_conclusion => self.is_conclusion})
  end
end

