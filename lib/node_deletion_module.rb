module NodeDeletionModule
  def self.included(base)
  end
  
  def delete_appropriate_nodes
    #just need ids and use select - don't need this, primary key on table
    Node.where('users_count = 0').delete_all
    if self.is_a? Node::UserNode
      ContextNode.where(user_node_id:self.id).each do |cn|
        cn.global_node_id = self.global_node_id
        cn.destroy
      end
    end
    delete_context_links
  end

  def delete_context_links
    unless Node::UserNode.exists?(user_id: self.user_id, global_node_id:self.global_node_id)
      Link::UserLink.where('user_id = ? AND (global_node_from_id = ? || global_node_to_id = ?)', self.user_id, self.global_node_id, self.global_node_id).destroy_all
    end
  end

end

