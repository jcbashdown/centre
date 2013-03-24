class LinksController < ApplicationController
  prepend_before_filter :signed_in_user
  before_filter :set_link_question

  def set_link_question
    if session[:active_links] == "to"
      question_id = session[:links_to_question]
    else
      question_id = session[:links_from_question]
    end
    if question_id
      @link_question = Question.find_by_id question_id
    else
      @link_question = nil
    end
  end

  def create
    @user_link = "Link::UserLink::#{params[:type]}UserLink".constantize.new(params[:global_link].merge(:question_id => @link_question.try(:id), :user => current_user))
    respond_to do |format|
      if @user_link.save
        format.js { render :partial => 'a_link', :locals=>{:link => @user_link.global_link, :direction=>params[:direction]} }
        format.json {render json: @user_link.to_json}
      else
        link_params = params[:global_link]
        blank_link = Link::GlobalLink.new(:global_node_from_id => link_params[:global_node_from_id], :global_node_to_id => link_params[:global_node_to_id])
        format.js { render :partial => 'a_link', :locals=>{:link => blank_link, :direction=>params[:direction]} }
        format.json {render json: false.to_json}
      end
    end
  end

  def update
    @global_link = Link::GlobalLink.find(params[:id])
    @user_link = Link::UserLink.where(:user_id => current_user.id, :global_link_id => @global_link.id)[0]
    respond_to do |format|
      if @user_link = @user_link.update_type(params[:type], @link_question)
        format.js { render :partial => 'a_link', :locals=>{:link=> @user_link.global_link, :direction=>params[:direction]} }
      else
        unless @user_link && @user_link.persisted?
          link_params = params[:global_link]
          link = Link::GlobalLink.new(:global_node_from_id => link_params[:global_node_from_id], :global_node_to_id => link_params[:global_node_to_id])
        else
          link = @user_link.global_link
        end
        format.js { render :partial => 'a_link', :locals=>{:link => link, :direction=>params[:direction]} }
      end
    end
  end

  def destroy
    @global_link = Link::GlobalLink.find(params[:id])
    @user_link = Link::UserLink.where(:user_id => current_user.id, :global_link_id => @global_link.id)[0]
    respond_to do |format|
      if @user_link.destroy
        link_params = params[:global_link]
        blank_link = Link::GlobalLink.new(:global_node_from_id => link_params[:global_node_from_id], :global_node_to_id => link_params[:global_node_to_id])
        format.js { render :partial => 'a_link', :locals=>{:link=>blank_link, :direction=>params[:direction]} }
      else
        format.js { render :partial => 'a_link', :locals=>{:link=>@user_link.global_link, :direction=>params[:direction]} }
      end
    end
  end
  
end
