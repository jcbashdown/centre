class GlobalUser < ActiveRecord::Base
  belongs_to :global
  belongs_to :user

  has_one :whole_argument, :as => :subject

  after_create :create_whole_argument
  after_create :destroy_whole_argument

  protected
  def create_whole_argument
    WholeArgument.create(:subject_type => 'GlobalUser', :subject_id => self.id)
  end

  def destroy_whole_argument
    self.whole_argument.destroy
  end
end
