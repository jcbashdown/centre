module LinkUpdateModule
  def self.included(base)
  end

  def update_sublinks
    update_user_link
    delete_non_user_links
    create_appropriate_links
  end

  def update_appropriate_links
    ContextLink.where('user_link_id = ?', user_link_id).each do |cl|
      unless cl.class == "ContextLink::#{link_kind}ContextLink".constantize
        cl.update_attributes!(:type => "ContextLink::#{link_kind}ContextLink")
      end
    end
  end

  def update_user_link
    self.user_link.update_attributes!(:type => "Link::UserLink::#{link_kind}UserLink")
  end

end

