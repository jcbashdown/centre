class QuestionsController < ApplicationController
  before_filter :signed_in_user, :only => :create

  def create
    @question = Question.where(params[:question])[0] || Question.new(params[:question])
    if @question.persisted?
      flash[:notice] = "Redirected to #{@question.name}"
    elsif @question.save
      flash[:notice] = @question.name+" created"
    else
      flash[:alert] = "Cannot create a blank question"
    end
    session[:nodes_question] = @question.try(:id)
    session[:links_to_question] = @question.try(:id)
    session[:links_from_question] = @question.try(:id)
    session[:arguments_question] = @question.try(:id)
    redirect_to nodes_path
  end

  def show
    @question = Question.find_by_id(params[:id])
    session[:nodes_question] = @question.try(:id)
    session[:links_to_question] = @question.try(:id)
    session[:links_from_question] = @question.try(:id)
    session[:arguments_question] = @question.try(:id)
    redirect_to nodes_path
  end

end
