module LinkUserMixin
  def self.included(base)
    base.belongs_to :link, :counter_cache => true
    base.belongs_to :user
  end
end
