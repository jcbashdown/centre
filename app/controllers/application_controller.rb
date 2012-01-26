class ApplicationController < ActionController::Base
  protect_from_forgery
  include FrontendHelpers::Html5Helper

  before_filter :set_current_user

  def set_current_user
    @user = current_user
  end
  
end
