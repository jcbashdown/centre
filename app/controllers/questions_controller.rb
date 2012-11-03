class QuestionsController < ApplicationController

  def create
    @question = Question.new(params[:question])
    if @question.save
      flash[:notice]=@question.name+" created"
    else
      flash[:alert] = "Cannot create a blank question"
    end
    redirect_to nodes_path(:question=>@question.id)
  end

end
