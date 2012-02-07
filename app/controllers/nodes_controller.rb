class NodesController < ApplicationController
  before_filter :signed_in_user, :except => [:show, :index]
  before_filter :find_node_order, :except => [:create, :update, :destroy, :add_or_edit_link]
  # GET /nodes
  # GET /nodes.json
  def find_node_order
    @order = params[:order]
    if @order == "strongest"
      @order_query = "page_rank desc"
    elsif @order == "weakest"
      @order_query = "page_rank asc"
    elsif @order == "newest"
      @order_query = "created_at desc"
    elsif @order == "older"
      @order_query = "created_at asc"
    else
      @order_query = "id asc"
    end
  end

  def add_or_edit_link
    node = params[:node]
    link_type = node[:link_ins_attributes].present? ? :link_ins_attributes : :link_tos_attributes
    short_link_type = node[:link_ins_attributes].present? ? :link_in : :link_to
    title = node[:link_ins_attributes].present? ? Node.find(node[link_type]["0"][:node_from]).title : Node.find(node[link_type]["0"][:node_to]).title 
    @node = Node.find(params[:id])
    tr_id = params[:link_id]
    if @node.update_attributes!(node)
      link = Link.find_or_initialize_by_node_from_and_node_to(node[link_type]["0"][:node_from], node[link_type]["0"][:node_to])
      if link.persisted?
        @user.links << link
      end
      new_id = link.id.present? ? link.id : "#{rand(Time.now.to_i)}#{Time.now.to_i}"
      value = node[link_type]["0"][:_destroy]=="1" ? nil : node[link_type]["0"][:value].to_i
      render :partial => 'new_link', :locals=>{:value => value, :old_id=>tr_id, :new_id=>new_id, :link=>link, :title=>title, :short_link_type=>short_link_type}
    else
      if node[link_type]["0"][:id].present?
        link = Link.find(node[link_type]["0"][:id])
        render :partial => 'new_link', :locals=>{:value => link.value, :old_id=>tr_id, :new_id=>tr_id, :link=>link, :title=>title, :short_link_type=>short_link_type}
      else
        link = Link.new(:node_from=>node[link_type]["0"][:node_from], :node_to=>node[link_type]["0"][:node_to])
        render :partial => 'new_link', :locals=>{:value => nil, :old_id=>tr_id, :new_id=>tr_id, :link=>link, :title=>title, :short_link_type=>short_link_type}
      end
    end
  end

  def index
    @nodes = Node.find(:all, :order => @order_query) 
    if request.xhr?
      render :index, :layout => false
    else
      # renders index view
    end
  end

  # GET /nodes/1
  # GET /nodes/1.json
  def show
    @nodes = Node.find(:all, :order => @order_query)
    @node = Node.find(params[:id])
    @links = Array.new
    @nodes_with_links = @node.all_with_link_ids 
    @nodes_with_links.each do |node|
      @links << node[:link_to]
    end

    if request.xhr?
      render :show, :layout => false
    else
      # renders show view
    end
  end

  # GET /nodes/new
  # GET /nodes/new.json
  def new
    @nodes = Node.find(:all, :order => @order_query)
    @node = Node.new
    @links = Array.new
    @nodes_with_links = @node.all_with_link_ids 
    @nodes_with_links.each do |node|
      @links << node[:link_to]
    end
    if request.xhr?
      render :new, :layout => false
    else
      # renders new view
    end
  end

  # GET /nodes/1/edit
  def edit
    @nodes = Node.find(:all, :order => @order_query)
    @node = Node.find(params[:id])
    @links = Array.new
    @nodes_with_links = @node.all_with_link_ids 
    @nodes_with_links.each do |node|
      @links << node[:link_to]
    end
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
