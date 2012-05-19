class ArgumentsController < ActionController::Base
  
  def show
    @gnu = GlobalNodeUser.find(params[:id])
    if @gnu.global_node_user_froms
      @froms_positive = @gnu.positive_global_node_user_froms
      @froms_negative = @gnu.negative_global_node_user_froms
      respond_to do |format|
        format.js {}
      end
    end
  end 
 
end
