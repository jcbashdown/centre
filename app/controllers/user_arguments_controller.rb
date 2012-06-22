class UserArgumentsController < ActionController::Base
  
  def show
    @node = GlobalNodeUser.find(params[:id])
    if @node.global_node_user_froms
      @previous = params[:path]
      @original= params[:original]
      respond_to do |format|
        format.js {}
        format.html {render(:partial => 'user_arguments/show', :locals => {:node => @node, :previous => @previous, :original => @original})}
      end
    end
  end 

  def index
    unless params[:user_id] && @user = User.find(params[:user_id])
      @user = current_user
    end
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
