class NodesController < ApplicationController
  before_filter :set_new_node, :only => [:index, :show]
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
    if request.xhr?
      render :show, :layout => false
    else
      # renders show view
    end
  end

  def create
    context_node = ContextNode.new({:user_id => current_user.id, :question_id => @node_question.try(:id)}.merge(params[:node]))
    respond_to do |format|
      if context_node.save
        @node = context_node.global_node
        format.json {render @node.to_json}
        format.html { redirect_to node_path(@node), notice: 'Node was successfully created.' }
      else
        format.json {render false.to_json}
        format.html { redirect_to nodes_path, notice: 'The Title was blank or already taken.' }
      end
    end
  end

  def update
    @global_node = Node::GlobalNode.find params[:id]
    @context_node = ContextNode.where(:user_id => current_user.id, :question_id => @node_question.try(:id), :global_node_id => params[:id])[0]
    @context_node.set_conclusion! params[:node][:is_conclusion]
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
    @context_node = ContextNode.where({:user_id => current_user.id, :question_id => @node_question.try(:id), :title => params[:node][:title]})[0]
    if @context_node
      redirect_to node_path(@context_node.global_node)
    end
  end
end
