class QuestionArgumentsController < ApplicationController
  
  def show
    @node = Node::QuestionNode.find(params[:id])
    @previous = params[:path]
    @original= params[:original]
    respond_to do |format|
      format.js {}
      format.html {render(:partial => 'question_arguments/show', :locals => {:node => @node, :previous => @previous, :original => @original})}
    end
  end 
 
  def index
    @previous = params[:path]
    respond_to do |format|
      format.js {}
      format.html { render(:partial => 'question_arguments/index', :locals => {:previous => @previous, :question => @argument_question}) }
    end
  end
 
end
