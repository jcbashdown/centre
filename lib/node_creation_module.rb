module NodeCreationModule
  def self.included(base)
  end
  
  def create_appropriate_nodes
    @new_nodes = []
    @existing_nodes_hash = {}
    new_nodes_hash = {}
    title_hash = {}
    node_title_id = find_or_create_node_title.id
    title_hash[:node_title_id] = node_title_id
    find_or_initialise_nodes node_title_id
    unless @new_nodes.empty?
      #test this properly - loading right ids?
      #even faster - composite primary key, no need to get back after insert as already know
      Node.import @new_nodes
      @new_nodes = synchronize @new_nodes, [:type, :user_id, :question_id, :node_title_id]
      @new_nodes.each do |node|
        new_nodes_hash[:"#{node.type.gsub("Node::", "").underscore}_id"] = node.id
      end
    end
    self.attributes = new_nodes_hash.merge(@existing_nodes_hash).merge(title_hash)
  end

  def find_or_create_node_title
    NodeTitle.where(:title => title)[0] || NodeTitle.create!(:title => title)
  end

  def find_or_initialise_nodes(node_title_id)
    find_or_initialise(Node::GlobalNode, {:node_title_id => node_title_id})
    find_or_initialise(Node::UserNode, {:user_id => user_id, :node_title_id => node_title_id})
    if question
      find_or_initialise(Node::QuestionNode, {:question_id => question_id, :node_title_id => node_title_id})
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

  #taken from import gem
  def synchronize(instances, keys=[self.primary_key])
    return if instances.empty?
  
    conditions = {}
    order = ""
    
    key_values = keys.map { |key| instances.map(&"#{key}".to_sym) }
    keys.zip(key_values).each { |key, values| conditions[key] = values }
    order = keys.map{ |key| "#{key} ASC" }.join(",")
    
    fresh_instances = Node.find( :all, :conditions=>conditions, :order=>order )
    instances.each do |instance|
      matched_instance = fresh_instances.detect do |fresh_instance|
        keys.all?{ |key| fresh_instance.send(key) == instance.send(key) }
      end
      
      if matched_instance
        instance.clear_aggregation_cache
        instance.clear_association_cache
        instance.instance_variable_set '@attributes', matched_instance.attributes
      end
    end
  end
end

