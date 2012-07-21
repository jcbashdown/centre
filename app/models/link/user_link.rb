class Link::UserLink < Link
  validates :user_id, :uniqueness => {:scope => [:node_from_id, :node_to_id]}
  belongs_to :global_link, :counter_cache => :users_count
  belongs_to :user_node_from_id, :foreign_key => :node_from_id
  belongs_to :user_node_to_id, :foreign_key => :node_to_id
end
