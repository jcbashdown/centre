class ArgumentsController < ApplicationController
  before_filter :set_new_node, :only => [:show]
  before_filter :set_nodes, :only => [:show]
  layout 'argument_builder'

  def show
    @node_question = Question.find((session[:nodes_question] = params[:id]))
  end

end
