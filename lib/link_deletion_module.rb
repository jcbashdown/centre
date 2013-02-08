module LinkDeletionModule
  def self.included(base)
  end

  def delete_appropriate_links
    delete_user_link
    delete_non_user_links
  end

  def delete_non_user_links
    Link.where('users_count = 0 && 
                (id = ? || 
                 id = ? 
                )', self.global_link_id, self.group_link_id,)
              .destroy_all
  end

  def delete_user_link
    self.user_link.try(:destroy)
  end

end

