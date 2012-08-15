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
    if params[:view_configuration]
      params[:view_configuration].each do |key, value|
        cookies[key] = {:value => value} if value
      end
    end
  end
  
  def set_nodes
    nodes_question = cookies[:nodes_question].present? ? cookies[:nodes_question].to_i : nil
    nodes_user = cookies[:nodes_user].present? ? cookies[:nodes_user].to_i : nil
    @nodes = Node.find_by_context(:nodes_question => nodes_question, :nodes_user => nodes_user, :nodes_query => cookies[:nodes_query], :page => params[:page])
  end

  def set_links_to
    links_question = cookies[:links_to_question].present? ? cookies[:links_to_question].to_i : nil
    links_user = cookies[:links_to_user].present? ? cookies[:links_to_user].to_i : nil
    @links_to = @node.find_view_links_to_by_context(:links_to_question => links_question, :links_to_user => links_user, :links_to_query => cookies[:links_to_query], :page => params[:page])
    #all view nodes are global nodes, no links represented, just global nodes - if this what created with
    #do do general method which takes direct whatever - dry for each direction
  end

  def set_links_from
    links_question = cookies[:links_from_question].present? ? cookies[:links_from_question].to_i : nil
    links_user = cookies[:links_from_user].present? ? cookies[:links_from_user].to_i : nil
    @links_from = @node.find_view_links_from_by_context(:links_from_question => links_question, :links_from_user => links_user, :links_from_query => cookies[:links_from_query], :page => params[:page])
  end
  
  def set_node
    @node = Node::GlobalNode.find cookies[:node_id]
  end
end
