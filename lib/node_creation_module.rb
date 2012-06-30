module NodeCreationModule
  def self.included(base)
  end
  
  def create_appropriate_nodes
    node_title = find_or_create_node_title
    
    Node.create(takes an array...). should return an array so can loop and set after. make sure type is correct as inserting straight to node...
    before create so will always get saved if just set (though test this)
  end

  def find_or_create_node_title

  end

  def find_or_create_global_node_params

  end

  def find_or_create_user_node_params

  end

  def find_or_create_question_node_params

  end

end

