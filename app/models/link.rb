class Link < ActiveRecord::Base

  class << self
    def get_klass conditions
      if conditions[:question] && conditions[:user]
        ContextLink
      elsif conditions[:question]
        Link::QuestionLink
      elsif conditions[:user]
        Link::UserLink
      else
        Link::GlobalLink
      end
    end
  end

end
