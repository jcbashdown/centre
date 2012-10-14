class NodesController < ApplicationController
  before_filter :signed_in_user, :except => [:show, :index]
  before_filter :set_nodes, :only => [:index, :show]
  before_filter :set_node, :only => [:show, :destroy]
  before_filter :set_links_from, :only => [:show]
  before_filter :set_links_to, :only => [:show]
  before_filter :redirect_if_new_exists, :only => [:create]

  def set_node
    @node = Node.find(params[:id])
  end

  def index
    @new_node = Node.new
    respond_to do |format|
      format.js { render :partial => 'current_nodes', :locals => {:nodes => @nodes}}
      format.json { render json: @nodes.to_json(:only => [:id, :title]) }
      format.html
    end
  end

  def show
    if current_user
      @gnu = ContextNode.where(:user_id=>current_user.id, :global_node_id=>@node.id, :question_id=>@node_question.try(:id))[0]
    end
    @new_node = Node.new
    if request.xhr?
      render :show, :layout => false
    else
      # renders show view
    end
  end

  def create
    context_node = ContextNode.new({:user_id => current_user.id, :question_id => @node_question}.merge(params[:node]))
    respond_to do |format|
      if context_node.save
        @node = context_node.global_node
        format.html { redirect_to node_path(@node), notice: 'Node was successfully created.' }
      else
        format.html { redirect_to nodes_path, notice: 'That Title has already been taken. Please use the existing node' }
      end
    end
  end

  def destroy
    context_node = ContextNode.with_all_associations.where(:user_id => current_user.id, :global_node_id => @node.id, :question_id => @node_question.try(:id))[0]
    if context_node.destroy
      respond_to do |format|
        format.html { redirect_to nodes_path }
        format.json { head :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to nodes_path }
        format.json { head :ok }
      end
    end
  end

  protected

  def redirect_if_new_exists
    @context_node = ContextNode.where({:user_id => current_user.id, :question_id => @node_question, :title => params[:node][:title]})[0]
    if @context_node
      redirect_to node_path(@context_node.global_node)
    end
  end

  def search_for_nodes type, question_id=nil
    nodes = type.search do
                     fulltext params[:find]
                     with :question_id, question_id if question_id
                     order_by(:id, :asc)
                     paginate(:page => params[:page], :per_page => 15)
                   end.results
  end

end
