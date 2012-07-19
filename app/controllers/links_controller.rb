class LinksController < ApplicationController
  before_filter :signed_in_user
  before_filter :set_node_limit
  #before_filter :set_node_order
  #before_filter :set_node_limit_order

  def create
    @context_link = "ContextLink::#{params[:type]}ContextLink".constantize.new(params[:global_link].merge(:question => @question, :user => current_user))
    respond_to do |format|
      if @context_link.save
        format.js { render :partial => 'a_link', :locals=>{:link => @context_link.global_link, :direction=>params[:direction]} }
      else
        link_params = params[:global_link]
        blank_link = Link::GlobalLink.new(:node_from_id => link_params[:global_node_from_id], :node_to_id => link_params[:global_node_to_id])
        format.js { render :partial => 'a_link', :locals=>{:link => blank_link, :direction=>params[:direction]} }
      end
    end
  end

  def update
    @global_link = Link::GlobalLink.find(params[:id])
    @context_link = ContextLink.with_all_associations.where(:question_id => @question.id, :user_id => current_user.id, :global_link_id => @global_link.id)[0]
    respond_to do |format|
      if @context_link.destroy && (@context_link = "ContextLink::#{params[:type]}ContextLink".constantize.create(params[:global_link].merge(:question => @question, :user => current_user)))
        format.js { render :partial => 'a_link', :locals=>{:global_link=> @context_link.global_link, :direction=>params[:direction]} }
      else
        unless @context_link && @context_link.persisted?
          link_params = params[:global_link]
          link = Link::GlobalLink.new(:node_from_id => link_params[:global_node_from_id], :node_to_id => link_params[:global_node_to_id])
        else
          link = @context_link.global_link
        end
        format.js { render :partial => 'a_link', :locals=>{:link => link, :direction=>params[:direction]} }
      end
    end
  end

  def destroy
    @global_link = Link::GlobalLink.find(params[:id])
    @context_link = ContextLink.with_all_associations.where(:question_id => @question.id, :user_id => current_user.id, :global_link_id => @global_link.id)[0]
    respond_to do |format|
      if @context_link.destroy
        link_params = params[:global_link]
        blank_link = Link::GlobalLink.new(:node_from_id => link_params[:global_node_from_id], :node_to_id => link_params[:global_node_to_id])
        format.js { render :partial => 'a_link', :locals=>{:link=>blank_link, :direction=>params[:direction]} }
      else
        format.js { render :partial => 'a_link', :locals=>{:link=>@context_link.global_link, :direction=>params[:direction]} }
      end
    end
  end
  
end
