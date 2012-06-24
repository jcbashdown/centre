module GlobalNodeMixin
  def self.included(base)
    base.belongs_to :global
  end
end

