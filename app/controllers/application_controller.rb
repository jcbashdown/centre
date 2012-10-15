require "#{Rails.root}/lib/view_configuration"
class ApplicationController < ActionController::Base
  include ViewConfiguration
  protect_from_forgery

  before_filter :set_questions
  before_filter :update_view_configuration
  before_filter :set_node_question

  def set_node_question
    if question_id = session[:nodes_question]
      @node_question = question_id.to_i
    else
      @node_question = nil
    end
  end
  
  def set_link_question
    if session[:active_links] == "to"
      question_id = session[:links_to_question]
    else
      question_id = session[:links_from_question]
    end
    if question_id
      @link_question = question_id.to_i
    else
      @link_question = nil
    end
  end

  def set_questions
    @new_question = Question.new
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
        session[key] = {:value => value} if (value && accepted_options[key])
      end
    end
  end
  
  def set_nodes
    nodes_question = session[:nodes_question].present? ? session[:nodes_question].to_i : nil
    nodes_user = session[:nodes_user].present? ? session[:nodes_user].to_i : nil
    @nodes = Node.find_by_context(:question => nodes_question, :user => nodes_user, :query => session[:nodes_query], :page => params[:page])
  end

  def set_links_to
    links_question = session[:links_to_question].present? ? session[:links_to_question].to_i : nil
    links_user = session[:links_to_user].present? ? session[:links_to_user].to_i : nil
    @links_to = @node.find_view_links_to_by_context(:question => links_question, :user => links_user, :query => session[:links_to_query], :page => params[:page])
  end

  def set_links_from
    links_question = session[:links_from_question].present? ? session[:links_from_question].to_i : nil
    links_user = session[:links_from_user].present? ? session[:links_from_user].to_i : nil
    @links_from = @node.find_view_links_from_by_context(:question => links_question, :user => links_user, :query => session[:links_from_query], :page => params[:page])
  end
  
  def set_node
    @node = Node::GlobalNode.find session[:node_id]
  end
end
