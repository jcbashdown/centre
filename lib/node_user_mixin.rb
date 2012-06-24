module NodeUserMixin
  def self.included(base)
    base.belongs_to :user
  end
end

