class UserLink < ActiveRecord::Base
  belongs_to :user
  belongs_to :link, :counter_cache => :users_count 
end
