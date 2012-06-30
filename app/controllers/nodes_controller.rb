class NodesController < ApplicationController
  before_filter :signed_in_user, :except => [:show, :index]
  before_filter :set_node_limit
  before_filter :set_nodes, :only => [:index, :show]
  before_filter :set_node, :only => [:show]
  before_filter :set_links, :only => [:show]
  before_filter :redirect_if_new_exists, :only => [:create]

  def set_node
    @node = Node.find(params[:id])
  end

  def set_links
    if @user
      @links_to = @user.user_from_node_links(@node, @question)
      @links_in = @user.user_to_node_links(@node, @question)
    else
      @links_to = @question.global_from_node_links(@node)
      @links_in = @question.global_to_node_links(@node)
    end
  end
  
  def set_nodes
    if params[:find]
      unless @question.name == "All"
        question_id =  @question.try(:id)
        type = GlobalNode
        @nodes = search_for_nodes(type, question_id)
      else
        type = Node
        @nodes = search_for_nodes(type)
      end
    else
      unless @question.name == "All"
        @nodes = @question.nodes.page.page(params[:page]).per(15).order(@order_query_all)
      else
        @nodes = Node.order(@order_query_all).page(params[:page]).per(15)
      end
    end
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
    if @user
      @gnu = GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :question_id=>@question.try(:id))[0]
    end
    @new_node = Node.new
    if request.xhr?
      render :show, :layout => false
    else
      # renders show view
    end
  end

  def create
    context_node = ContextNode.new({:user=>@user, :question_id => @question.try(:id)}.merge(params[:node]))
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
    context_node = ContextNode.with_all_associations.where(:user_id=>@user.id, :node_title_id=>params[:id], :question_id=>@question.try(:id))[0]
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
    @context_node = ContextNode.where({:user_id => @user.id, :question_id => @question.try(:id), :title => params[:node][:title]})[0]
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
