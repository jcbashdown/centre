module LinkDeletionModule
  def self.included(base)
  end

  def delete_appropriate_links
    delete_user_link
    delete_non_user_links
  end

  def delete_non_user_links
    Link::GroupLink.where('users_count = 0').destroy_all
    Link::GlobalLink.where('users_count = 0').destroy_all
  end

  def delete_user_link
    self.user_link.try(:destroy)
  end

end

