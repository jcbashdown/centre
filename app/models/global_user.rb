class GlobalUser < ActiveRecord::Base
  belongs_to :global
  belongs_to :user

  has_one :argument, :as => :subject

  after_create :create_argument
  after_create :destroy_argument

  protected
  def create_argument
    Argument.create(:subject_type => 'GlobalNode', :subject_id => self.id)
  end

  def destroy_argument
    self.argument.destroy
  end
end
