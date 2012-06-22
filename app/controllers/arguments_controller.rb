class UserArgumentsController < ActionController::Base
  
  def show
    @node = GlobalNodeUser.find(params[:id])
    if @node.node_froms
      @previous = params[:path]
      @original= params[:original]
      respond_to do |format|
        format.js {}
        format.html {render(:partial => 'arguments/show', :locals => {:node => @node, :previous => @previous, :original => @original})}
      end
    end
  end 
 
end
