class Argument < ActiveRecord::Base
  attr_accessible :content, :subject_id, :subject_type

  belongs_to :subject, :polymorphic => true
end
