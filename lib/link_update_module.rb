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
      ContextLink.where('user_link_id = ?', user_link_id).each do |cl|
        unless cl.id == self.id || cl.class == "ContextLink::#{new_type}ContextLink".constantize
          cl.update_attributes!(:type => "ContextLink::#{new_type}ContextLink", :new_type => new_type, :no_other_context_links => true)
        end
      end
    end
  end

  def update_user_link
    self.user_link.update_attribute(:type, "Link::UserLink::#{new_type}UserLink")
  end

end

