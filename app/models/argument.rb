class Argument < ActiveRecord::Base
  attr_accessible :content, :subject_id, :subject_type
  after_create :set_default_attributes

  belongs_to :subject, :polymorphic => true

  protected
  def set_default_attributes
    self.content = ""
    save
  end
end
