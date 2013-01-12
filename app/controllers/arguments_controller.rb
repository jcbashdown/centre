class ArgumentsController < ApplicationController
  layout 'homepage'

  def show
    @node_question = session[:nodes_question] = Question.find(params[:id])
  end

end
