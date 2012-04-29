class NodesController < ApplicationController
  before_filter :signed_in_user, :except => [:show, :index]
  before_filter :set_node_limit
  before_filter :set_node_order
  before_filter :set_node_limit_order
  before_filter :set_nodes, :only => [:index, :show, :edit, :new]
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
  
  def set_nodes
    if params[:find]
      question_id =  @question.id
      @global_nodes = GlobalNode.search do
                        fulltext params[:find]
                        with :global_id, question_id
                        order_by(:id, :asc)
                        paginate(:page => params[:page], :per_page => 5)
                      end.results
    else
      @global_nodes = @question.global_nodes.paginate(:page => params[:page], :per_page=>5).order(@order_query_all)
    end
  end

  def index
    @new_node = Node.new
    respond_to do |format|
      format.html
      format.js  {render :layout => false }
      format.json { render json: @global_nodes }
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

  def new
    if request.xhr?
      render :new, :layout => false
    else
      # renders new view
    end
  end

  def edit
    if request.xhr?
      render :edit, :layout => false
    else
      # renders edit view
    end
  end

  def create
    @gnu = GlobalNodeUser.new({:user=>@user, :global=>@question}.merge(params[:node]))
    respond_to do |format|
      if @gnu.save
        @node = @gnu.node
        format.html { redirect_to nodes_path(@limit_order), notice: 'Node was successfully created.' }
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
    gnu = GlobalNodeUser.where(:user_id=>@user.id, :node_id=>node.id, :global_id=>@question.id)[0]
    if gnu.destroy
      respond_to do |format|
        format.html { redirect_to "/" }
        format.json { head :ok }
      end
    else
      respond_to do |format|
        format.html { redirect_to "/" }
        format.json { head :ok }
      end
    end
  end
  
end
