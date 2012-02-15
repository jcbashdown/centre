class ApplicationController < ActionController::Base
  #todo - no create, update or add/edit links if no current user, no new and edit actions too
  #no links to edit and new, all link boxes disabled

  protect_from_forgery
  include FrontendHelpers::Html5Helper

  before_filter :set_current_user
  before_filter :set_questions

  def find_limit_order
    order = params[:order]
    question_id = params[:question]
    unless question_id
      question_id = 1
    end
    unless order
      order = 'older'
    end
    if order == "strongest"
      @order_query = "page_rank desc"
    elsif order == "weakest"
      @order_query = "page_rank asc"
    elsif order == "newer"
      @order_query = "created_at desc"
    elsif order == "older"
      @order_query = "created_at asc"
    else
      @order_query = "id asc"
    end
    @question = Global.find(question_id)
    @limit_order = {:question => question_id, :order => order}
  end

  def set_current_user
    @user = current_user
  end

  def set_questions
    @questions = Global.all.map { |question| [question.name, question.id] }
    @questions << ['New/Search For Question', '#new']
  end

  def signed_in_user
    unless @user 
      flash[:notice] = "You must be a signed in user to view this page"
      redirect_to "/"
    end
  end
  
end
