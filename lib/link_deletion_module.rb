module LinkDeletionModule
  def self.included(base)
  end

  def delete_appropriate_links
    delete_user_link
    delete_non_user_links
    delete_context_links_for_user_link
  end

  def delete_context_links_for_user_link
    ContextLink.where('user_link_id = ?', user_link_id)
                     .destroy_all
  end
  
  def delete_non_user_links
    Link.where('users_count = 0 && 
                (id = ? || 
                 id = ? 
                )', global_link_id, question_link_id,)
              .destroy_all
  end

  def delete_user_link
    self.user_link.try(:destroy)
  end

end

