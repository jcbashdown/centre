module NodeDeletionModule
  def self.included(base)
  end
  
  def delete_appropriate_nodes
#    delete_user_node_if_allowed
#    delete_question_node_if_allowed
#    delete_global_node_if_allowed
#    delete_node_title_if_allowed
    Node.where('node_title_id = ? && 
               ((users_count = 0 && user_id IS NULL && question_id IS NULL) || 
                (users_count = 0 && user_id IS NULL && question_id = ?) ||
                (users_count = 0 && user_id = ? && question_id IS NULL)
               )',
               node_title_id, question_id, user_id
              ).delete_all
    #http://apidock.com/rails/ActiveRecord/Relation/delete_all
  end

#  def delete_global_node_if_allowed
#    if global_node.reload.global_node_users_count < 1
#      global_node.destroy
#    else
#      new_is_conclusion = (GlobalNodeUser.where(:global_id => self.global.id, :node_id => self.node.id, :is_conclusion => true).count > GlobalNodeUser.where(:global_id => self.global.id, :node_id => self.node.id, :is_conclusion => false).count)
#      global_node.update_attributes!(:is_conclusion => new_is_conclusion) unless new_is_conclusion==global_node.is_conclusion
#    end
#  end
#
#  def delete_node_user_if_allowed
#    if node_user.reload.global_node_users_count < 1
#      node_user.destroy
#    end
#  end
#
#  def delete_node_if_allowed
#    if node.reload.global_node_users_count < 1 
#      node.destroy
#    end
#  end
end

