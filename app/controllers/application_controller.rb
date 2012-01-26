class ApplicationController < ActionController::Base
  protect_from_forgery
  include FrontendHelpers::Html5Helper

  before_filter :set_current_user

  def set_current_user
    @user = current_user
  end
  
  def set_user_session
    unless current_user
      session = UserSession.build  
    end
  end

end
