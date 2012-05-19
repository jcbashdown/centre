class GlobalNode < ActiveRecord::Base
  searchable do
    text :title
    integer :global_id
    integer :id
    double :page_rank
    time :created_at
  end
  belongs_to :global
  belongs_to :node
  has_many :global_node_users

  has_one :positive_node_argument, :as => :subject, :foreign_key => 'subject_id'
  has_one :negative_node_argument, :as => :subject, :foreign_key => 'subject_id'

  validates :node, :presence => true
  validates :title, :presence => true

  validates_uniqueness_of :node_id, :scope => [:global_id]

end
