class LinksController < ApplicationController
  before_filter :signed_in_user
  before_filter :set_node_limit
  before_filter :set_node_order
  before_filter :set_node_limit_order

  def create
    @glu = GlobalLinkUser.new(params[:link].merge(:global => @question, :user => @user))
    respond_to do |format|
      if @glu.save
        format.js { render :partial => 'a_link', :locals=>{:link => @glu.link, :type=>params[:type]} }
      else
        link_params = params[:link]
        link_params.delete(:value)
        blank_link = Link.new(link_params)
        format.js { render :partial => 'a_link', :locals=>{:link => blank_link, :type=>params[:type]} }
      end
    end
  end

  def update
    @glu = GlobalLinkUser.find(params[:id])
    respond_to do |format|
      if @glu.destroy && (@glu = GlobalLinkUser.create(params[:link].merge(:global => @question, :user => @user)))
        format.js { render :partial => 'a_link', :locals=>{:link=> @glu.link, :type=>params[:type]} }
      else
        unless @glu
          link_params = params[:link]
          link_params.delete(:value)
          link = Link.new(link_params)
        else
          link = @glu.link
        end
        format.js { render :partial => 'a_link', :locals=>{:link => link, :type=>params[:type]} }
      end
    end
  end

  def destroy
    @glu = GlobalLinkUser.find(params[:id])
    respond_to do |format|
      if @glu.destroy
        link_params = params[:link]
        link_params.delete(:value)
        blank_link = Link.new(link_params)
        format.js { render :partial => 'a_link', :locals=>{:link=>blank_link, :type=>params[:type]} }
      else
        format.js { render :partial => 'a_link', :locals=>{:link=>@glu.link, :type=>params[:type]} }
      end
    end
  end
end
