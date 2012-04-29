class ApplicationController < ActionController::Base
  #todo - no create, update or add/edit links if no current user, no new and edit actions too
  #no links to edit and new, all link boxes disabled

  protect_from_forgery

  before_filter :set_current_user
  before_filter :set_questions

  def set_node_order
    @order = params[:order]
    unless @order
      @order = 'older'
    end
    if @order == "strongest"
      @order_query = [:page_rank, :desc]
      @order_query_all = 'page_rank desc'
    elsif @order == "weakest"
      @order_query = [:page_rank, :asc]
      @order_query_all = 'page_rank asc'
    elsif @order == "newer"
      @order_query = [:created_at, :desc]
      @order_query_all = 'created_at desc'
    elsif @order == "older"
      @order_query = [:created_at, :asc]
      @order_query_all = 'created_at asc'
    else
      @order_query = [:id, :asc]
      @order_query_all = 'id asc'
    end
  end

  def set_node_limit
    question_id = params[:question]
    unless question_id
      @question = Global.find_by_name("All")
      question_id = @question.id
    else
      @question = Global.find(question_id)
    end
  end
  
  def set_node_limit_order
    @limit_order = {:question => @question.id, :order => @order}
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
