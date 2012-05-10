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

  after_create :create_node_arguments
  after_create :destroy_node_arguments

  protected
  def create_node_arguments
    PositiveNodeArgument.create(:subject_type => 'GlobalNode', :subject_id => self.id)
    NegativeNodeArgument.create(:subject_type => 'GlobalNode', :subject_id => self.id)
  end

  def destroy_node_arguments
    self.positive_node_argument.destroy
    self.negative_node_argument.destroy
  end
end
