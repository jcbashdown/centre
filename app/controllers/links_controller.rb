class LinksController < ApplicationController
  prepend_before_filter :signed_in_user
  before_filter :set_link_question

  def set_link_question
    @link_question = Question.find_by_id session[:links_question]
  end

  def create
    @user_link = "Link::UserLink::#{params[:type]}UserLink".constantize
      .create(params[:global_link]
              .merge(
                :question_id => @link_question.try(:id), 
                :user => current_user)
             )
    respond_to do |format|
      rerender_link @user_link, format
    end
  end

  def update
    user_link = Link::UserLink
      .where(:user_id => current_user.id, 
             :global_link_id => params[:id])[0]
    @user_link = user_link.update_type(params[:type], @link_question)
    respond_to do |format|
      rerender_link @user_link, format
    end
  end

  def destroy
    @user_link = Link::UserLink
      .where(:user_id => current_user.id, 
             :global_link_id => params[:id])[0]
    @user_link.destroy
    respond_to do |format|
      rerender_link @user_link, format
    end
  end

  def rerender_link user_link, format
    if user_link.try(:persisted?)
      format.js { render({
                           partial: 'a_link', 
                           locals: {
                                     link: @user_link.global_link, 
                                     direction: params[:direction]
                                   } 
                        }) 
                }
      format.json { render({
                             json: @user_link.to_json 
                          })
                  }
    else
      format.js { render({
                           partial: 'a_link', 
                           locals: {
                                     link: place_holder_link,
                                     direction: params[:direction]
                                   } 
                        }) 
                }
      format.json { render({
                             json: false.to_json 
                          })
                  }
    end
  end

  def place_holder_link
    link_params = params[:global_link]
    blank_link = Link::GlobalLink
      .new(:global_node_from_id => link_params[:global_node_from_id], 
           :global_node_to_id => link_params[:global_node_to_id])
  end
  
end
