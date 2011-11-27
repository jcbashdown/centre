class LinksController < ApplicationController
  def links_in_edit 
    @links= Links.all 
    if request.xhr?
      render :links_in_edit :layout => false
    else
      # renders index view
    end
  end
  def links_in_show
    @links= Links.all 
    if request.xhr?
      render :links_in_show:layout => false
    else
      # renders index view
    end
  end
