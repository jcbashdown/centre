class Question < ActiveRecord::Base
  validates :name, :presence => true, :uniqueness => true, :format => { :with => /^((?!all).)*$/i,
    :message => "Please use the pre defined 'All'" }

end
