module NodeCreationModule
  def self.included(base)
  end
  
  def create_appropriate_nodes
    self.global_node = find_or_create_global_node
  end

  def find_or_create_global_node
    Node::GlobalNode.where(:title => self.title)[0] || Node::GlobalNode.create({:title => self.title, :is_conclusion => self.is_conclusion})
  end
end

