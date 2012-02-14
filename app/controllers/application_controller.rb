class ApplicationController < ActionController::Base
  #todo - no create, update or add/edit links if no current user, no new and edit actions too
  #no links to edit and new, all link boxes disabled

  protect_from_forgery
  include FrontendHelpers::Html5Helper

  before_filter :set_current_user
  before_filter :set_questions

  def set_current_user
    @user = current_user
  end

  def set_questions
    @questions = Global.all.map { |question| [question.name, question.id] }
    @questions << ['New Question', '#new']
  end

  def signed_in_user
    unless @user 
      flash[:notice] = "You must be a signed in user to view this page"
      redirect_to "/"
    end
  end
  
end
