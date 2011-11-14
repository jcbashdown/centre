class Node < ActiveRecord::Base
  validates :title, :presence => true
end
