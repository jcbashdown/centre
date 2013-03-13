class Link::UserLink < Link
  belongs_to :global_link, :counter_cache => :users_count
  belongs_to :user
  validates :user_id, :uniqueness => {:scope => [:global_link_id]}

  has_many :user_groups, :foreign_key => :user_id, :primary_key => :user_id
  has_many :group_links, :through => :user_groups


end
