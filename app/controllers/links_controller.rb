class LinksController < ApplicationController
  def links_in_edit 
    @links= Link.all 
    if request.xhr?
      render :links_in_edit, :layout => false
    else
      # renders links_in_edit
    end
  end
  def links_in_show
    @links= Link.all 
    if request.xhr?
      render :links_in_show, :layout => false
    else
      # renders links_in_show
    end
  end
  def links_to_edit 
    @links= Link.all 
    if request.xhr?
      render :links_to_edit, :layout => false
    else
      # renders links_to_edit
    end
  end
  def links_to_show
    @links= Link.all 
    if request.xhr?
      render :links_to_show, :layout => false
    else
      # renders links_to_show
    end
  end
end
