class Link::UserLink < Link
  validates :user_id, :uniqueness => {:scope => [:node_from_id, :node_to_id]}
end
