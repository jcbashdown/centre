class Link::UserLink < Link
  validates :node_from_id, :uniqueness => {:scope => [:node_to_id]}
end
