class Link::UserLink < Link
  belongs_to :global_link, :counter_cache => :users_count
  validates :user_id, :uniqueness => {:scope => [:node_from_id, :node_to_id]}
end
