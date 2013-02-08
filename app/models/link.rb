class Link < ActiveRecord::Base

  class << self
    def get_klass conditions
      if conditions[:group] && conditions[:user]
        ContextLink
      elsif conditions[:group]
        Link::GroupLink
      elsif conditions[:user]
        Link::UserLink
      else
        Link::GlobalLink
      end
    end
  end

end
