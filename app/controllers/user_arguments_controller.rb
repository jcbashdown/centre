class UserArgumentsController < ApplicationController
  prepend_before_filter :update_view_configuration
  
  def show
    @node = ContextNode.find(params[:id])
    @previous = params[:path]
    @original= params[:original]
    respond_to do |format|
      format.js {}
      format.html {render(:partial => 'user_arguments/show', :locals => {:node => @node, :previous => @previous, :original => @original})}
    end
  end 

  def index
    unless params[:user_id] && @user = User.find(params[:user_id])
      @user = current_user
    end
    @previous = params[:path]
    respond_to do |format|
      format.js {}
      format.html { render(:partial => 'user_arguments/index', :locals => {:previous => @previous, :question => @argument_question}) }
    end
  end
 
  def update_view_configuration
    super
    set_node_question
    set_argument_question
  end
end
