class NodesController < ApplicationController
  before_filter :signed_in_user, :except => [:show, :index]
  before_filter :set_node_limit
  before_filter :set_node_order
  before_filter :set_node_limit_order
  before_filter :set_nodes, :only => [:index, :show]
  before_filter :set_node, :only => [:show]
  before_filter :set_links, :only => [:show]
  before_filter :redirect_if_new_exists, :only => [:create]
  before_filter :set_global, :only => [:create, :destroy, :show]
  before_filter :set_argument, :only => [:show]

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

  def set_argument
    if current_user
      positive = GlobalNodeUser.where(:node_id => @node.id, :global_id =>  @global.id, :user_id => @user.id)[0].positive_node_argument.content
      p positive
      if positive && positive.length > 0
        @positive_argument = Morph.from_xml(%Q|<positive>|+positive+%Q|</positive>|)
      end
      negative = GlobalNodeUser.where(:node_id => @node.id, :global_id =>  @global.id, :user_id => @user.id)[0].negative_node_argument.content
      p negative
      p negative.length > 0
      if negative && negative.length > 0
        p "neg"
        @negative_argument = Morph.from_xml(%Q|<negative>|+negative+%Q|</negative>|)
      end
=begin
x.gsub!("\n", "")
<positive>
  <global-node-user>
    <downvotes-count type=\"integer\">0</downvotes-count>
    <equivalents-count type=\"integer\">0</equivalents-count>
    <id type=\"integer\">2</id>
    <is-conclusion type=\"boolean\">false</is-conclusion>
    <page-rank type=\"float\">0.0</page-rank>
    <title>another</title>
    <upvotes-count type=\"integer\">1</upvotes-count>
    <negative/>
    <positive>
      <global-node-user>
        <downvotes-count type=\"integer\">0</downvotes-count>
        <equivalents-count type=\"integer\">0</equivalents-count>
        <id type=\"integer\">3</id>
        <is-conclusion type=\"boolean\">false</is-conclusion>
        <page-rank type=\"float\">0.0</page-rank>
        <title>a third</title>
        <upvotes-count type=\"integer\">0</upvotes-count>
        <negative/>
        <positive/>
      </global-node-user>
    </positive>
  </global-node-user>
</positive>
this:
#<Morph::Positive:0x0000000395ee28 @global_node_users=[#<Morph::GlobalNodeUser:0x0000000490e9b8 @created_at=2012-05-14 19:36:56 UTC, @downvotes_count=0, @equivalents_count=0, @global_id=2, @global_link_users_count=0, @global_node_id=3, @id=3, @ignore=true, @is_conclusion=false, @node_id=3, @node_user_id=3, @page_rank=0.0, @title="a third", @updated_at=2012-05-14 19:36:56 UTC, @upvotes_count=0, @user_id=1>, #<Morph::GlobalNodeUser:0x000000030239a8 @created_at=2012-05-14 19:36:56 UTC, @downvotes_count=0, @equivalents_count=0, @global_id=2, @global_link_users_count=1, @global_node_id=3, @id=3, @ignore=true, @is_conclusion=false, @node_id=3, @node_user_id=3, @page_rank=0.0, @title="a third", @updated_at=2012-05-14 19:36:56 UTC, @upvotes_count=0, @user_id=1>], @positive=#<Morph::Positive:0x000000040a1b18 @global_node_user=#<Morph::GlobalNodeUser:0x000000040c6760 @created_at=2012-05-14 19:36:51 UTC, @downvotes_count=0, @equivalents_count=0, @global_id=2, @global_link_users_count=1, @global_node_id=2, @id=2, @ignore=true, @is_conclusion=false, @node_id=2, @node_user_id=2, @page_rank=0.0, @title="another", @updated_at=2012-05-14 19:37:16 UTC, @upvotes_count=1, @user_id=1>>> 

comes from

this:

"<positive>
    <positive>

  <global-node-user>
    <body nil=\"true\"/>
    <created-at type=\"datetime\">2012-05-14T19:36:51Z</created-at>
    <downvotes-count type=\"integer\">0</downvotes-count>
    <equivalents-count type=\"integer\">0</equivalents-count>
    <global-id type=\"integer\">2</global-id>
    <global-link-users-count type=\"integer\">1</global-link-users-count>
    <global-node-id type=\"integer\">2</global-node-id>
    <id type=\"integer\">2</id>
    <ignore type=\"boolean\">true</ignore>
    <is-conclusion type=\"boolean\">false</is-conclusion>
    <node-id type=\"integer\">2</node-id>
    <node-user-id type=\"integer\">2</node-user-id>
    <page-rank type=\"float\">0.0</page-rank>
    <title>another</title>
    <updated-at type=\"datetime\">2012-05-14T19:37:16Z</updated-at>
    <upvotes-count type=\"integer\">1</upvotes-count>
    <user-id type=\"integer\">1</user-id>
  </global-node-user>

    </positive>
      <global-node-user>
        <body nil=\"true\"/>
        <created-at type=\"datetime\">2012-05-14T19:36:56Z</created-at>
        <downvotes-count type=\"integer\">0</downvotes-count>
        <equivalents-count type=\"integer\">0</equivalents-count>
        <global-id type=\"integer\">2</global-id>
        <global-link-users-count type=\"integer\">0</global-link-users-count>
        <global-node-id type=\"integer\">3</global-node-id>
        <id type=\"integer\">3</id>
        <ignore type=\"boolean\">true</ignore>
        <is-conclusion type=\"boolean\">false</is-conclusion>
        <node-id type=\"integer\">3</node-id>
        <node-user-id type=\"integer\">3</node-user-id>
        <page-rank type=\"float\">0.0</page-rank>
        <title>a third</title>
        <updated-at type=\"datetime\">2012-05-14T19:36:56Z</updated-at>
        <upvotes-count type=\"integer\">0</upvotes-count>
        <user-id type=\"integer\">1</user-id>
      </global-node-user>
  <global-node-user>
    <body nil=\"true\"/>
    <created-at type=\"datetime\">2012-05-14T19:36:56Z</created-at>
    <downvotes-count type=\"integer\">0</downvotes-count>
    <equivalents-count type=\"integer\">0</equivalents-count>
    <global-id type=\"integer\">2</global-id>
    <global-link-users-count type=\"integer\">1</global-link-users-count>
    <global-node-id type=\"integer\">3</global-node-id>
    <id type=\"integer\">3</id>
    <ignore type=\"boolean\">true</ignore>
    <is-conclusion type=\"boolean\">false</is-conclusion>
    <node-id type=\"integer\">3</node-id>
    <node-user-id type=\"integer\">3</node-user-id>
    <page-rank type=\"float\">0.0</page-rank>
    <title>a third</title>
    <updated-at type=\"datetime\">2012-05-14T19:36:56Z</updated-at>
    <upvotes-count type=\"integer\">0</upvotes-count>
    <user-id type=\"integer\">1</user-id>
  </global-node-user>
</positive>"

sub all new lines

sub all closing positives and negatives

remove all gnu ends

insert gnu end before every positive and negative

replace every starting positive and negative with self enclosing
=end
      p %Q|<positive>|+positive+%Q|</positive>|
      p %Q|<negative>|+negative+%Q|</negative>|
    else

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
