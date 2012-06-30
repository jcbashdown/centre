require "#{Rails.root}/lib/link_creation_module.rb"

class ContextLink < ActiveRecord::Base
  include LinkCreationModule
end
