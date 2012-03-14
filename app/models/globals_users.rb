class GlobalsUsers < ActiveRecord::Base
  belongs_to :global
  belongs_to :user
end
