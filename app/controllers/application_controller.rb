class ApplicationController < ActionController::Base
  #todo - no create, update or add/edit links if no current user, no new and edit actions too
  #no links to edit and new, all link boxes disabled

  protect_from_forgery
  include FrontendHelpers::Html5Helper

  before_filter :set_current_user

  def set_current_user
    @user = current_user
  end
  
end
