module NodeDeletionModule
  def self.included(base)
  end
  
  def delete_appropriate_nodes
    Node.where('node_title_id = ? && 
               ((users_count = 0 && user_id IS NULL && question_id IS NULL) || 
                (users_count = 0 && user_id IS NULL && question_id = ?) ||
                (users_count = 0 && user_id = ? && question_id IS NULL)
               )',
               node_title_id, question_id, user_id
              ).delete_all
  end

end

