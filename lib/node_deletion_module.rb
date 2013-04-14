module NodeDeletionModule
  def self.included(base)
  end
  
  def delete_appropriate_nodes
    #just need ids and use select - don't need this, primary key on table
    Node.where('users_count = 0').delete_all
    delete_context_links
  end

  def delete_context_links
    Link::UserLink.where('user_id = ? AND (global_node_from_id = ? || global_node_to_id = ?)', self.user_id, self.global_node_id, self.global_node_id).destroy_all
  end

end

