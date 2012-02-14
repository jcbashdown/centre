class GlobalsController < ApplicationController
  def new
    @global = Global.new
    render :new, :layout => false
  end

  def create
    @global = Global.new(params[:global])
    if @global.save!
      flash[:notice]=@global.name+" created"
    else
      flash[:alert] = "could not be created"
    end
    redirect_to nodes_path(:question=>@global.id)
  end

end
