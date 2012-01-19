class ApplicationController < ActionController::Base
  before_filter :set_current_user
  protect_from_forgery
  include FrontendHelpers::Html5Helper

  def set_current_user
    @user = current_user
    p @user
  end

end
