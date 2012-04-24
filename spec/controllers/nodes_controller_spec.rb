require 'spec_helper'

describe NodesController do
  before do
    @user = FactoryGirl.create(:user)
    controller.stub(:current_user).and_return @user
    @global = FactoryGirl.create(:global)
    Global.stub(:find).and_return @global
  end
  # This should return the minimal set of attributes required to create a valid
  # Node. As you add validations to Node, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {:title => 'title', :text => ''}
  end

  describe "GET index" do
    before do
      @node = Node.new
      Node.stub(:new).and_return @node
    end
    it "assigns all nodes as @global_nodes for the current global" do
      global_node_user = GlobalNodeUser.create!({:user=>@user, :global=>@global}.merge(valid_attributes))
      global_node = global_node_user.global_node
      get :index, :question => @global.id
      assigns(:global_nodes).should eq([global_node])
    end
    it 'should assign node' do
      get :index, :question => @global.id
      assigns(:new_node).should == @node
    end
  end

  describe "GET show" do
    before do
      @node = Node.new
      Node.stub(:new).and_return @node
      global_node_user = GlobalNodeUser.create!({:user=>@user, :global=>@global}.merge(valid_attributes))
      @global_node_one = global_node_user.global_node 
      @node_one = global_node_user.node 
      @params = {:id=>@node_one.id, :question => @global.id}
      controller.stub(:set_links)
    end
    it 'should assign node' do
      get :show, @params
      assigns(:new_node).should == @node
    end
    it "assigns all nodes as @global_nodes for the current global" do
      get :show, @params
      assigns(:global_nodes).should eq([@global_node_one])
    end
    context 'when node is node one' do
      it 'should call set_node' do
        controller.should_receive(:set_node)
        get :show, @params
      end
      it 'should call set_node' do
        get :show, @params
        assigns(:node).should == @node_one
      end
      it 'should set user links' do
        controller.should_receive(:set_links)
        get :show, @params
      end
      context 'when set_links is unstubbed' do
        before do
          controller.unstub!(:set_links)
        end
        it 'should set the links for the gnu or potential gnu' do
          pending
        end
      end
    end
  end

  describe "GET new" do
    before do
      global_node_user = GlobalNodeUser.create!({:user=>@user, :global=>@global}.merge(valid_attributes))
      @global_node_one = global_node_user.global_node 
    end
    it "assigns all nodes as @global_nodes for the current global" do
      get :new, :question => @global.id
      assigns(:global_nodes).should eq([@global_node_one])
    end
    context 'when no node' do
      before do
        @node = Node.new
        Node.stub(:new).and_return @node
      end
      it 'should call set_node' do
        controller.should_receive(:set_node)
        get :new
      end
      it 'should assign node' do
        get :new
        assigns(:node).should == @node
      end
    end
  end

  describe "GET edit" do
    before do
      global_node_user = GlobalNodeUser.create!({:user=>@user, :global=>@global}.merge(valid_attributes))
      @global_node_one = global_node_user.global_node 
      @node_one = global_node_user.node 
      @params = {:id=>@node_one.id}
      controller.stub(:set_links)
    end
    it "assigns all nodes as @global_nodes for the current global" do
      get :edit, :question => @global.id
      assigns(:global_nodes).should eq([@global_node_one])
    end
    context 'when node is node one' do
      it 'should call set_node' do
        controller.should_receive(:set_node)
        get :edit, @params
      end
      it 'should call set_node' do
        get :edit, @params
        assigns(:node).should == @node_one
      end
      it 'should set user links' do
        controller.should_receive(:set_links)
        get :edit, @params
      end
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Node" do
        expect {
          post :create, :node => valid_attributes, :question => @global.id
        }.to change(Node, :count).by(1)
      end

      it "creates a new GlobalNodeUser" do
        expect {
          post :create, :node => valid_attributes, :question => @global.id
        }.to change(GlobalNodeUser, :count).by(1)
      end

      it "creates a new GlobalNode" do
        expect {
          post :create, :node => valid_attributes, :question => @global.id
        }.to change(GlobalNode, :count).by(1)
      end

      it 'should have called create on global node user' do
        gnu = GlobalNodeUser.new({:user => @user, :global => @global}.merge({"title" => 'title', "text" => ''}))
        GlobalNodeUser.should_receive(:new).with({:user => @user, :global => @global}.merge({"title" => 'title', "text" => ''})).and_return gnu
        post :create, :node => valid_attributes, :question => @global.id
      end

      it "assigns a newly created node as @node" do
        post :create, :node => valid_attributes, :question => @global.id
        assigns(:node).should be_a(Node)
        assigns(:gnu).should be_a(GlobalNodeUser)
        assigns(:node).should be_persisted
      end

      it "redirects to the created node" do
        post :create, :node => valid_attributes, :question => @global.id
        node = Node.last
        response.should redirect_to nodes_path(:order => 'older', :question => @global.id)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved node as @node" do
        # Trigger the behavior that occurs when invalid params are submitted
        GlobalNodeUser.any_instance.stub(:save).and_return(false)
        post :create, :node => {}, :question => @global.id
        assigns(:gnu).should be_a_new(GlobalNodeUser)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        GlobalNodeUser.any_instance.stub(:save).and_return(false)
        post :create, :node => {}, :question => @global.id
        response.should redirect_to nodes_path(:order => 'older', :question => @global.id)
      end
    end
  end

#  describe "PUT update" do
#    before do
#      @node = Node.create! valid_attributes, :question => @global.id
#      @gnu = GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>Global.find_by_name('All'))
#      Node.stub(:find).and_return @node
#    end
#    it 'should receive the correct parameters' do
#      @node.should_receive(:update_attributes).with({:text => 'some text'})
#      Node.stub(:find).and_return @node
#      put :update, :id => @node.id, :node => {'text' => 'some text', 'these' => 'params'}
#    end
#
#    describe "with invalid params" do
#      #call find
#      #assign node
#      #update with text
#      #render node edit
#      it "assigns the node as @node" do
#        node = @node
#        # Trigger the behavior that occurs when invalid params are submitted
#        Node.stub(:find).and_return node
#        Node.stub(:update_attributes).and_return false
#        put :update, :id => node.id, :node => {}
#        assigns(:node).should eq(node)
#      end
#
#      it "re-renders the 'edit' template" do
#        node = @node
#        # Trigger the behavior that occurs when invalid params are submitted
#        node.stub(:update_attributes).and_return false
#        Node.stub(:find).and_return node
#        put :update, :id => node.id, :node => {}
#        response.should render_template("edit")
#      end
#    end
#  end

  describe "DELETE destroy" do
    before do
      @node = Node.create! valid_attributes, :question => @global.id
      @gnu = GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
      GlobalNodeUser.stub(:where).and_return [@gnu]
      Node.stub(:find).and_return @node
    end

    it 'should call destroy on the current gnu' do
      @gnu.should_receive(:destroy)
      delete :destroy, :id => @node.id
    end

    it "redirects to the nodes list" do
      @gnu.stub(:destroy)
      delete :destroy, :id => @node.id
      response.should redirect_to("/")
    end
  end

end
