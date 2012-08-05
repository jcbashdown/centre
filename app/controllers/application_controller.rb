class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_questions
  before_filter :update_view_configuration

#  def set_node_order
#    @order = params[:order]
#    unless @order
#      @order = 'older'
#    end
#    if @order == "strongest"
#      @order_query = [:page_rank, :desc]
#      @order_query_all = 'page_rank desc'
#    elsif @order == "weakest"
#      @order_query = [:page_rank, :asc]
#      @order_query_all = 'page_rank asc'
#    elsif @order == "newer"
#      @order_query = [:created_at, :desc]
#      @order_query_all = 'created_at desc'
#    elsif @order == "older"
#      @order_query = [:created_at, :asc]
#      @order_query_all = 'created_at asc'
#    else
#      @order_query = [:id, :asc]
#      @order_query_all = 'id asc'
#    end
#  end

  def set_node_limit
    question_id = params[:question]
    if question_id
      @question = Question.find(question_id)
    else
      @question = nil
    end
  end
  
  #def set_node_limit_order
  #  @limit_order = {:question => @question.id, :order => @order}
  #end

  def set_questions
    @questions = Question.all.map { |question| [question.name, question.id] }
    @questions << ['New/Search For Question', '#new']
  end

  def signed_in_user
    unless current_user 
      flash[:notice] = "You must be a signed in user to view this page"
      redirect_to "/"
    end
  end
  
  def update_view_configuration
    cookies[:nodes_question] = {:value => params[:view_configuration][:nodes_question]} if params[:view_configuration] && params[:view_configuration][:nodes_question]
    cookies[:nodes_user] = {:value => params[:view_configuration][:nodes_user]} if params[:view_configuration] && params[:view_configuration][:nodes_user]
    cookies[:nodes_query] = {:value => params[:view_configuration][:nodes_query]} if params[:view_configuration] && params[:view_configuration][:nodes_query]
    cookies[:argument_user] = {:value => params[:view_configuration][:argument_user]} if params[:view_configuration] && params[:view_configuration][:argument_user]
    cookies[:argument_question] = {:value => params[:view_configuration][:argument_question]} if params[:view_configuration] && params[:view_configuration][:argument_question]
    cookies[:links_question] = {:value => params[:view_configuration][:links_question]} if params[:view_configuration] && params[:view_configuration][:links_question]
    cookies[:links_user] = {:value => params[:view_configuration][:links_user]} if params[:view_configuration] && params[:view_configuration][:links_user]
    cookies[:links_query] = {:value => params[:view_configuration][:links_query]} if params[:view_configuration] && params[:view_configuration][:links_query]
#    if params[:view_configuration]
#      params[:view_configuration].each do |key, value|
#        cookies[key] = {:value => value} if value
#      end
#    end
  end
end
