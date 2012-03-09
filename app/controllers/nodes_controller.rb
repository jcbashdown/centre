class NodesController < ApplicationController
  before_filter :signed_in_user, :except => [:show, :index]
  before_filter :find_limit_order, :except => [:create, :update, :destroy, :add_or_edit_link]
  #before filters apply to non action methods as well?
  before_filter :set_node, :only => [:show, :edit, :new]
  before_filter :set_links, :only => [:show, :edit]

  def set_node
    unless params[:id]
      @node = Node.new
    else
      @node = Node.find(params[:id])
    end
  end
  #how to test this - preset node? stub @node as method?
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

  # GET /nodes/1
  # GET /nodes/1.json
  def show
    @nodes = @question.nodes.paginate(:page => params[:page], :per_page=>5).order(@order_query)
    #@links = Array.new
    #@nodes_with_links = @node.all_with_link_ids 
    #@nodes_with_links.each do |node|
    #  @links << node[:link_to]
    #end

    if request.xhr?
      render :show, :layout => false
    else
      # renders show view
    end
  end

  # GET /nodes/new
  # GET /nodes/new.json
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
    #@links = Array.new
    #@nodes_with_links = @node.all_with_link_ids 
    #@nodes_with_links.each do |node|
    #  @links << node[:link_to]
    #end
    if request.xhr?
      render :edit, :layout => false
    else
      # renders edit view
    end
  end

  # POST /nodes
  # POST /nodes.json
  def create
    @node = Node.new(params[:node])
    # new is not currently going to work... need to submit all at once or two stage process? one end point for links?
    respond_to do |format|
      if @node.save
        @user.nodes << @node
        format.html { redirect_to @node, notice: 'Node was successfully created.' }
        format.json { render json: @node, status: :created, location: @node }
      else
        format.html { render action: "new" }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /nodes/1
  # PUT /nodes/1.json
  def update
    @node = Node.find(params[:id])
    #symbolise keys
    respond_to do |format|
      if @node.update_attributes(params[:node])
        format.html { redirect_to @node, notice: 'Node was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @node.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /nodes/1
  # DELETE /nodes/1.json
  def destroy
    @node = Node.find(params[:id])
    @node.destroy

    respond_to do |format|
      format.html { redirect_to "/" }
      format.json { head :ok }
    end
  end
  
end
