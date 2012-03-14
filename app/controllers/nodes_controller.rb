class NodesController < ApplicationController
  before_filter :signed_in_user, :except => [:show, :index]
  before_filter :find_limit_order, :except => [:create, :update, :destroy, :add_or_edit_link]
  before_filter :set_node, :only => [:show, :edit, :new]
  before_filter :set_links, :only => [:show, :edit]

  def set_node
    unless params[:id]
      @node = Node.new
    else
      @node = Node.find(params[:id])
    end
  end

  def set_links
    if @user
      @links_to = @user.user_from_node_links(@node)
      @links_in = @user.user_to_node_links(@node)
    else
      @links_to = @node.construct_from_node_links
      @links_in = @node.construct_to_node_links
    end
  end

  def index
    @nodes = @question.nodes.paginate(:page => params[:page], :per_page=>5).order(@order_query)
    if request.xhr?
      render :index, :layout => false
    else
      # renders index view
    end
  end

  def show
    @nodes = @question.nodes.paginate(:page => params[:page], :per_page=>5).order(@order_query)
    if request.xhr?
      render :show, :layout => false
    else
      # renders show view
    end
  end

  def new
    @nodes = @question.nodes.paginate(:page => params[:page], :per_page=>5).order(@order_query)
    @node = Node.new
    if request.xhr?
      render :new, :layout => false
    else
      # renders new view
    end
  end

  # GET /nodes/1/edit
  def edit
    @nodes = @question.nodes.paginate(:page => params[:page], :per_page=>5).order(@order_query)
    if request.xhr?
      render :edit, :layout => false
    else
      # renders edit view
    end
  end

  def create
    @node = Node.new(params[:node])
    respond_to do |format|
      if @node.save
        GlobalsNodesUsers.create(:user=>@user, :node=>@node, :global=>@question)
        @user.nodes << @node
        format.html { redirect_to @node, notice: 'Node was successfully created.' }
        format.json { render json: @node, status: :created, location: @node }
      else
        format.html { render action: "new" }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @node = Node.find(params[:id])
    respond_to do |format|
      if @node.update_attributes(params[:node])
        @gnu = GlobalsNodesUsers.where(:user=>@user, :node=>@node, :global=>@question)[0] || GlobalsNodesUsers.create(:user=>@user, :node=>@node, :global=>@question)
        format.html { redirect_to @node, notice: 'Node was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @node = Node.find(params[:id])
    @node.destroy
    @gnu = GlobalsNodesUsers.where(:user=>@user, :node=>@node, :global=>@question)[0]
    @gnu.destroy
    respond_to do |format|
      format.html { redirect_to "/" }
      format.json { head :ok }
    end
  end
  
end
