module NodeDeletionModule
  def self.included(base)
  end
  
  def delete_appropriate_nodes
    #just need ids and use select - don't need this, primary key on table
-    Node.where('title = ? && 
-               ((users_count < 2 && user_id IS NULL && question_id IS NULL) || 
-                (users_count < 2 && user_id = ? && question_id IS NULL)
-               )',
-               self.title, self.user_id
              ).delete_all
    delete_context_links
  end

  def delete_context_links
    ContextLink.where('context_node_from_id = ? || context_node_to_id = ?', id, id).each {|cl| cl.destroy_all_for_user_link}
  end

end

