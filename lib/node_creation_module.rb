module NodeCreationModule
  def self.included(base)
  end
  
  def create_appropriate_nodes
    title_hash = {}
    title_hash[:node_title_id] = find_or_create_node_title.id
    existing_nodes_hash = find_or_create_nodes
    self.attributes = existing_nodes_hash.merge(title_hash)
  end

  def find_or_create_node_title
    NodeTitle.where(:title => title)[0] || NodeTitle.create!(:title => title)
  end

  def find_or_create_nodes
    hash = {
             :global_node_id => find_or_create(Node::GlobalNode),
             :user_node_id   => find_or_create(Node::UserNode, {:user_id => user_id})
           }
    if question
      hash.merge({:question_node_id => find_or_create(Node::QuestionNode, {:question_id => question_id})})
    else
      hash
    end
  end  

  def find_or_create(the_class, the_params={})
    the_class.where({:node_title_id => node_title_id}.merge(the_params))[0].try(:id) || the_class.create!({:node_title_id => node_title_id, :title => title, :is_conclusion => is_conclusion}.merge(the_params)).id
  end

end

