module NodeDeletionModule
  def self.included(base)
  end
  
  def delete_appropriate_nodes
    #just need ids and use select - don't need this, primary key on table
    Node.where('node_title_id = ? && 
               ((users_count = 1 && user_id IS NULL && question_id IS NULL) || 
                (users_count = 1 && user_id IS NULL && question_id = ?) ||
                (users_count = 1 && user_id = ? && question_id IS NULL)
               )',
               node_title_id, question_id, user_id
              ).delete_all
    delete_context_links
  end

  def delete_context_links
    ContextLink.where('context_node_from_id = ? ||
                       context_node_to_id = ?',
                       id, id
                     ).delete_all
  end

end

