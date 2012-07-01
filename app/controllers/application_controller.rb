class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_questions

#  def set_node_order
#    @order = params[:order]
#    unless @order
#      @order = 'older'
#    end
#    if @order == "strongest"
#      @order_query = [:page_rank, :desc]
#      @order_query_all = 'page_rank desc'
#    elsif @order == "weakest"
#      @order_query = [:page_rank, :asc]
#      @order_query_all = 'page_rank asc'
#    elsif @order == "newer"
#      @order_query = [:created_at, :desc]
#      @order_query_all = 'created_at desc'
#    elsif @order == "older"
#      @order_query = [:created_at, :asc]
#      @order_query_all = 'created_at asc'
#    else
#      @order_query = [:id, :asc]
#      @order_query_all = 'id asc'
#    end
#  end

  def set_node_limit
    question_id = params[:question]
    if question_id
      @question = Question.find(question_id)
    else
      @question = nil
    end
    p "question"
  end
  
  #def set_node_limit_order
  #  @limit_order = {:question => @question.id, :order => @order}
  #end

  def set_questions
    p params
    @questions = Question.all.map { |question| [question.name, question.id] }
    @questions << ['New/Search For Question', '#new']
  end

  def signed_in_user
    unless current_user 
      flash[:notice] = "You must be a signed in user to view this page"
      redirect_to "/"
    end
    p "signed_in"
  end
  
#  def update_session
#    if params[:change_view] && decoded = JSON.parse((params[:change_view]))
#      session[:view_configuration] = {
#                                       :nodes => {
#                                                   :question => decoded[:nodes][:question] ? decoded[:nodes][:question] : nil
#                                                   :user => decoded[:nodes][:user] ? decoded[:nodes][:user] : nil
#                                                   :order => decoded[:nodes][:order] ? decoded[:nodes][:order] : nil
#                                                   :query => decoded[:nodes][:query] ? decoded[:nodes][:query] : nil
#                                                 }
#                                       :argument => {
#                                                      :user =>
#                                                      :question => 
#                                                    }
#                                       :link => {
#                                                   :question => 
#                                                   :user => 
#                                                   :order => 
#                                                   :query => 
#                                                }
#                                     }
#    end
#  end
end
