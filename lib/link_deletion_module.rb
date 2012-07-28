module LinkDeletionModule
  def self.included(base)
  end

  def delete_appropriate_links
    delete_user_links
    delete_non_user_links
  end
  
  def delete_non_user_links
    Link.where('users_count = 0 && 
                (id = ? || 
                 id = ? 
                )', global_link_id, question_link_id,)
              .destroy_all
  end

  def delete_user_links
    Link.where('(id = ? )', user_link_id)
              .destroy_all
  end

end

