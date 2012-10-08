class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_questions
  before_filter :update_view_configuration
  before_filter :set_node_question

  def set_node_question
    if question_id = cookies[:nodes_question]
      @node_question = question_id.to_i
    else
      @node_question = nil
    end
  end
  
  def set_link_question
    case cookies[:active_links]
    when "from"
      question_id = cookies[:links_from_question]
    when "to"
      question_id = cookies[:links_to_question]
    when nil
      question_id = cookies[:links_from_question]
    end
    if question_id
      @link_question = question_id.to_i
    else
      @link_question = nil
    end
  end

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
    @nodes = Node.find_by_context(:question => nodes_question, :user => nodes_user, :query => cookies[:nodes_query], :page => params[:page])
  end

  def set_links_to
    links_question = cookies[:links_to_question].present? ? cookies[:links_to_question].to_i : nil
    links_user = cookies[:links_to_user].present? ? cookies[:links_to_user].to_i : nil
    @links_to = @node.find_view_links_to_by_context(:question => links_question, :user => links_user, :query => cookies[:links_to_query], :page => params[:page])
  end

  def set_links_from
    links_question = cookies[:links_from_question].present? ? cookies[:links_from_question].to_i : nil
    links_user = cookies[:links_from_user].present? ? cookies[:links_from_user].to_i : nil
    @links_from = @node.find_view_links_from_by_context(:question => links_question, :user => links_user, :query => cookies[:links_from_query], :page => params[:page])
  end
  
  def set_node
    @node = Node::GlobalNode.find cookies[:node_id]
  end
end
