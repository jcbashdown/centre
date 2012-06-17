class UserArgumentsController < ActionController::Base
  
  def show
    @node = GlobalNodeUser.find(params[:id])
    if @node.node_froms
      @previous = params[:path]
      @original= params[:original]
      respond_to do |format|
        format.js {}
      end
    end
  end 
 
  def index
    unless @user = User.find(params[:user])
      @user = current_user
    end
    unless @question = Global.find(params[:global])
      @question = Global.find_by_name("All")
    end
    @previous = params[:path]
    respond_to do |format|
      format.js {}
    end
  end
 
end
