module LinkDeletionModule
  def self.included(base)
  end

  def delete_appropriate_links
    Link.where('users_count = 0 && 
                (id = ? || 
                 id = ? ||
                 id = ?
                )', global_link_id, question_link_id, user_link_id)
              .delete_all
  end

end

