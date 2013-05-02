module LinkDeletionModule
  def self.included(base)
  end

  def delete_appropriate_links
    delete_non_user_links
  end

  def delete_non_user_links
    Link::GroupLink.where('users_count = 0').destroy_all
    Link::GlobalLink.where('users_count = 0').destroy_all
  end

end
