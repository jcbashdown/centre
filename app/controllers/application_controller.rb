require "#{Rails.root}/lib/view_configuration"
class ApplicationController < ActionController::Base
  include ViewConfiguration
  protect_from_forgery

  before_filter :set_questions

  def set_questions
    @new_question = Question.new
    @questions = Question.all
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
        session[key] = (value.present? ?  value : nil) if accepted_options[key]
      end
    end
    if current_user
      session[:nodes_user] ||= current_user.id 
      session[:links_to_user] ||= current_user.id 
      session[:links_from_user] ||= current_user.id 
      session[:arguments_user] ||= current_user.id 
    end
  end
  
  def set_nodes
    context = {
                :question => session[:nodes_question],
                #:user => session[:nodes_user], 
                :query => session[:nodes_query], 
                :page => params[:nodes_page] ? params[:nodes_page] : 1
              }
    @nodes = Node.find_by_context(context)
    unless @nodes.try(:any?)
      @nodes = Node.find_by_context(context.except(:query))
    end
  end

  def set_links_to
    @links_to = set_links "to", page = params[:links_to_page]
  end

  def set_links_from
    @links_from = set_links "from", page = params[:links_from_page] 
  end

  def set_links direction, page
    context = ({
                :question => session[:"links_#{direction}_question"], 
                :user => session[:"links_#{direction}_user"], 
                :query => session[:"links_#{direction}_query"], 
                :page => page
              })
    nodes = @node.find_view_links_by_context(direction, context)
    unless nodes.try(:any?)
      nodes = @node.find_view_links_by_context(direction, context.except(:query))
    end
    nodes
  end

  def set_new_node
    @new_node = Node.new
  end
  
end
