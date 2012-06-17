class GlobalArgumentsController < ActionController::Base
  
  def show
    @node = GlobalNode.find(params[:id])
    if @node.global_node_froms
      @previous = params[:path]
      @original= params[:original]
      respond_to do |format|
        format.js {}
      end
    end
  end 
 
  def index
    unless params[:global_id] && @question = Global.find(params[:global_id])
      @question = Global.find_by_name("All")
    end
    @previous = params[:path]
    respond_to do |format|
      format.js {}
    end
  end
 
end
