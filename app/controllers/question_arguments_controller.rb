class QuestionArgumentsController < ApplicationController
  
  def show
    @node = Node::GlobalNode.find(params[:id])
    @previous = params[:path]
    @original= params[:original]
    respond_to do |format|
      format.js {}
    end
  end 
 
  def index
    @previous = params[:path]
    respond_to do |format|
      format.js {}
      format.html { render(:partial => 'question_arguments/index', :locals => {:previous => @previous, :argument_question => @argument_question, :argument_user => @argument_user}) }
    end
  end
 
  def update_view_configuration
    session[:argument_user] = nil
    super
    set_node_question
    set_argument_question
  end
end
