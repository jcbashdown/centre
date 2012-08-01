module LinkUpdateModule
  def self.included(base)
  end

  def update_sublinks
    update_user_link
    delete_non_user_links
    create_appropriate_links
  end

  def update_appropriate_links
    unless no_other_context_links
      ContextLink.where('user_link_id = ? AND id != ? AND type != ?', self.user_link_id, self.id, "ContextLink::#{self.new_type}ContextLink").each do |cl|
        #how to do this? update without validations but with callbacks - link update_attribute but many variables, then do for user link to
        cl.update_attributes!(:type => "ContextLink::#{self.new_type}ContextLink", :new_type => self.new_type, :no_other_context_links => true)
      end
    end
  end

  def update_user_link
    # given this, find or create userlink is forgone - updated, not created
    self.user_link.update_attribute(:type, "Link::UserLink::#{self.new_type}UserLink")
  end

end

