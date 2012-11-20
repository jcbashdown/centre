class QuestionArgumentsController < ActionController::Base
  
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
    unless params[:global_id] && @question = Global.find(params[:global_id])
      @question = Global.find_by_name("All")
    end
    @previous = params[:path]
    respond_to do |format|
      format.js {}
      format.html { render(:partial => 'global_arguments/index', :locals => {:previous => @previous, :question => @question}) }
    end
  end
 
end
