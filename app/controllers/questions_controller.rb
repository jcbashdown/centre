class QuestionsController < ApplicationController

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
    redirect_to nodes_path
  end

end
