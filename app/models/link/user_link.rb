class Link::UserLink < Link
  belongs_to :global_link, :counter_cache => :users_count
  validates :user_id, :uniqueness => {:scope => [:global_link_id]}
end
