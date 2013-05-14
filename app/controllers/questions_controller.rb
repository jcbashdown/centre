class QuestionsController < ApplicationController
  prepend_before_filter :signed_in_user, :only => [:create]
  before_filter :set_new_node, :only => [:show]
  before_filter :set_nodes, :only => [:show]
  layout 'argument_builder'

  def create
    @question = Question.where(params[:question])[0] || Question.new(params[:question])
    if @question.persisted?
      flash[:notice] = "Redirected to #{@question.name}"
    elsif @question.save
      flash[:notice] = "#{@question.name} created"
    else
      flash[:alert] = "Cannot create a blank question"
      set_question_if_unset
    end
    redirect_to @question ? @question : "/"
  end

  def destroy
    respond_to do |format|
      if current_user.may_destroy(@question) && @question.destroy
        if @question.id == session[:nodes_question].to_i
          format.json { render json: "/".to_json }
        else
          format.json { render json: params[:id].to_json }
        end
      else
        format.json { render json: false.to_json }
      end
    end
  end

  def show
    respond_to do |format|
      if params[:user] && (user_id = params[:user_id])
        format.json {@question.argument(user:User.find(user_id)).to_json}
        format.html
      else
        format.json {@question.argument.to_json}
        format.html
      end
    end
  end
  
  def update_view_configuration
    super
    session[:nodes_question] = params[:id]
    session[:links_question] = params[:id]
    session[:arguments_question] = params[:id]
    set_question_if_unset
    set_node_question
    set_argument_question
  end
  
  def set_question_if_unset
    @question ||= Question.find_by_id(params[:id] ? params[:id] : session[:nodes_question])
  end
  
  def set_node_question
    @node_question = @question
  end

  def set_argument_question
    @argument_question = @question
  end

end
