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
    cookies[:current_node] = {:value => params[:view_configuration][:current_node]}
  end
  
  def set_nodes
    nodes_question = cookies[:nodes_question].present? ? cookies[:nodes_question].to_i : nil
    nodes_user = cookies[:nodes_user].present? ? cookies[:nodes_user].to_i : nil
    @nodes = Node.find_by_context(:nodes_question => nodes_question, :nodes_user => nodes_user, :nodes_query => cookies[:nodes_query], :page => params[:page])
  end

  def set_links_to
    links_question = cookies[:links_question].present? ? cookies[:links_question].to_i : nil
    links_user = cookies[:links_user].present? ? cookies[:links_user].to_i : nil
    @links_to = @node.find_view_links_to_by_context(:links_question => links_question, :links_user => links_user, :links_query => cookies[:links_query], :page => params[:page])
    #@node.global_node?
    #each node type has method on - type is actually useful?
    #from to should be a link type - then do from class passing in node?
    #do do general method which takes direct whatever - dry for each direction
  end

  def set_links_from
    links_question = cookies[:links_question].present? ? cookies[:links_question].to_i : nil
    links_user = cookies[:links_user].present? ? cookies[:links_user].to_i : nil
    @links_from = @node.find_view_links_from_by_context(:links_question => links_question, :links_user => links_user, :links_query => cookies[:links_query], :page => params[:page])
  end
end
