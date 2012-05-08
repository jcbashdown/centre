class NodesController < ApplicationController
  before_filter :signed_in_user, :except => [:show, :index]
  before_filter :set_node_limit
  before_filter :set_node_order
  before_filter :set_node_limit_order
  before_filter :set_nodes, :only => [:index, :show]
  before_filter :set_node, :only => [:show]
  before_filter :set_links, :only => [:show]
  before_filter :redirect_if_new_exists, :only => [:create]
  before_filter :set_global, :only => [:create, :destroy]

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
        question_id =  @question.id
        type = GlobalNode
        @nodes = search_for_nodes(type, question_id)
      else
        type = Node
        @nodes = search_for_nodes(type)
      end
    else
      unless @question.name == "All"
        @nodes = @question.nodes.paginate(:page => params[:page], :per_page=>5).order(@order_query_all)
      else
        @nodes = Node.order(@order_query_all).paginate(:page => params[:page], :per_page=>5)
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
    @new_node = Node.new
    if request.xhr?
      render :show, :layout => false
    else
      # renders show view
    end
  end

  def create
    @gnu = GlobalNodeUser.new({:user=>@user, :global=>@global}.merge(params[:node]))
    respond_to do |format|
      if @gnu.save
        @node = @gnu.node
        format.html { redirect_to node_path(@gnu.node, @limit_order), notice: 'Node was successfully created.' }
        format.json { render json: @node, status: :created, location: nodes_path(@limit_order) }
      else
        format.html { redirect_to nodes_path(@limit_order), notice: 'That Title has already been taken. Please use the existing node' }
        format.json { render json: @gnu.errors, status: :unprocessable_entity }
      end
    end
  end

#  def update
#    @node = Node.find(params[:id])
#    text = params[:node][:text] ? params[:node][:text] : ""
#    respond_to do |format|
#      if @node.update_attributes({:text=>text})
#        @gnu = GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@question.id)[0] || GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@question)
#        @gn = GlobalNode.where(:node_id=>@node.id, :global_id=>@question.id)[0]
#        format.html { redirect_to @node, notice: 'Node was successfully updated.' }
#        format.json { head :ok }
#      else
#        format.html { render action: "edit" }
#        format.json { render json: @node.errors, status: :unprocessable_entity }
#      end
#    end
#  end

  def destroy
    node = Node.find(params[:id])
    gnu = GlobalNodeUser.where(:user_id=>@user.id, :node_id=>node.id, :global_id=>@global.id)[0]
    if gnu.destroy
      respond_to do |format|
        format.html { redirect_to nodes_path(@limit_order) }
        format.json { head :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to nodes_path(@limit_order) }
        format.json { head :ok }
      end
    end
  end

  protected

  def redirect_if_new_exists
    @gnu = GlobalNodeUser.where({:user_id => @user.id, :global_id => @question.id, :title => params[:node][:title]})[0]
    if @gnu
      redirect_to node_path(@gnu.node, @limit_order)
    end
  end

  def search_for_nodes type, question_id=nil
    nodes = type.search do
                     fulltext params[:find]
                     with :global_id, question_id if question_id
                     order_by(:id, :asc)
                     paginate(:page => params[:page], :per_page => 5)
                   end.results
  end

  def set_global
    @global = (@question.name == 'All') ? Global.find_by_name('Unclassified') : @question
  end
  
end
