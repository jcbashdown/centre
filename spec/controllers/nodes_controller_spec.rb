require 'spec_helper'

describe NodesController do
  before do
    @user = Factory(:user)
    controller.stub(:current_user).and_return @user
    @global = Factory(:global)
    Global.stub(:find).and_return @global
  end
  # This should return the minimal set of attributes required to create a valid
  # Node. As you add validations to Node, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {:title => 'title'}
  end

  describe "GET index" do
    it "assigns all nodes as @nodes for the current global" do
      node = Node.create! valid_attributes
      node.globals << @global
      get :index
      assigns(:nodes).should eq([node])
    end
  end

  describe "GET show" do
    context 'when node is node one' do
      before do
        @node_one = Factory(:node)
        @params = {:id=>@node_one.id}
        controller.stub(:set_links)
      end
      it 'should call set_node' do
        controller.should_receive(:set_node)
        get :show, @params
      end
      it 'should call set_node' do
        get :show, @params
        assigns(:node).should == @node_one
      end
      context 'when user is @user' do
        it 'should set user links' do
          controller.should_receive(:set_links)
          get :show, @params
        end
      end
    end
  end

  describe "GET new" do
    context 'when no node' do
      before do
        @node = Node.new
        Node.stub(:new).and_return @node
      end
      it 'should call set_node' do
        controller.should_receive(:set_node)
        get :new
      end
      it 'should call set_node' do
        get :new
        assigns(:node).should == @node
      end
      context 'when user is @user' do
        it 'should set user links' do
          controller.should_not_receive(:set_links)
          get :new, @params
        end
      end
    end
  end

  describe "GET edit" do
    context 'when node is node one' do
      before do
        @node_one = Factory(:node)
        @params = {:id=>@node_one.id}
        controller.stub(:set_links)
      end
      it 'should call set_node' do
        controller.should_receive(:set_node)
        get :edit, @params
      end
      it 'should call set_node' do
        get :edit, @params
        assigns(:node).should == @node_one
      end
      context 'when user is @user' do
        it 'should set user links' do
          controller.should_receive(:set_links)
          get :edit, @params
        end
      end
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Node" do
        expect {
          post :create, :node => valid_attributes
        }.to change(Node, :count).by(1)
      end

      it "creates a new GlobalNodeUser" do
        expect {
          post :create, :node => valid_attributes
        }.to change(GlobalNodeUser, :count).by(2)
      end

      it "creates a new GlobalNode" do
        expect {
          post :create, :node => valid_attributes
        }.to change(GlobalNode, :count).by(2)
      end

      it 'should have called create on global node user' do
        GlobalNodeUser.should_receive(:create)
        post :create, :node => valid_attributes
      end

      it "assigns a newly created node as @node" do
        post :create, :node => valid_attributes
        assigns(:node).should be_a(Node)
        assigns(:node).should be_persisted
      end

      it "redirects to the created node" do
        post :create, :node => valid_attributes
        node = Node.last
        response.should redirect_to node
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved node as @node" do
        # Trigger the behavior that occurs when invalid params are submitted
        Node.any_instance.stub(:save).and_return(false)
        post :create, :node => {}
        assigns(:node).should be_a_new(Node)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Node.any_instance.stub(:save).and_return(false)
        post :create, :node => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    before do
      @node = Node.create! valid_attributes
      @gnu = GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>Global.find_by_name('All'))
      Node.stub(:find).and_return @node
    end
    it 'should receive the correct parameters' do
      @node.should_receive(:update_attributes).with({:text => 'some text'})
      Node.stub(:find).and_return @node
      put :update, :id => @node.id, :node => {'text' => 'some text', 'these' => 'params'}
    end
    ### integration tests for two cases###
    describe "with valid params and an existing node global user combination for all and global node for all when outside of all" do
      before do
        @gnu = GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>Global.find_by_name('All'))
      end

      it 'should create a gnu for the current combination' do
        put :update, :id => @node.id, :node => {'text' => 'some text', 'these' => 'params'}
        GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].should be_a(GlobalNodeUser)
      end

      it 'should create a gn for the current combination' do
        put :update, :id => @node.id, :node => {'text' => 'some text', 'these' => 'params'}
        GlobalNode.where(:node_id=>@node.id, :global_id=>@global.id)[0].should be_a(GlobalNode)
      end

      it 'should increase gnu count by one' do
        expect {
          put :update, :id => @node.id, :node => {'text' => 'some text', 'these' => 'params'}
        }.to change(GlobalNodeUser, :count).by(1)
      end

      it 'should increase gn count by one' do
        expect {
          put :update, :id => @node.id, :node => {'text' => 'some text', 'these' => 'params'}
        }.to change(GlobalNode, :count).by(1)
      end

      it 'should update is conclusion and xml for current gnu combination' do
        pending
      end

      it 'should update is conclusion and xml for current gn combination' do
        pending
      end

      it "assigns the requested node as @node" do
        put :update, :id => @node.id, :node => {'text' => 'some text', 'these' => 'params'}
        assigns(:node).should eq(@node)
      end

      it 'should assign the current gnu as gnu' do
        put :update, :id => @node.id, :node => {'text' => 'some text', 'these' => 'params'}
        assigns(:gnu).should be_a(GlobalNodeUser)
        assigns(:gnu).global.should eq(@global)
        assigns(:gnu).user.should eq(@user)
        assigns(:gnu).node.should eq(@node)
      end

      it 'should assign the current gn as gn' do
        put :update, :id => @node.id, :node => {'text' => 'some text', 'these' => 'params'}
        assigns(:gn).should be_a(GlobalNode)
        assigns(:gn).global.should eq(@global)
        assigns(:gn).node.should eq(@node)
      end

      it "redirects to the node" do
        node = Node.create! valid_attributes
        Node.stub(:find).and_return node
        put :update, :id => node.id, :node => valid_attributes
        response.should redirect_to node
      end
    end

    describe "with valid params for a new node global user combination and an existing node global for all outside of all" do
      before do
        @user = Factory(:user, :email=>"user@email.com")
        @controller.stub(:current_user).and_return @user
        @gn = GlobalNode.create(:node=>@node, :global=>Global.find_by_name('All'))
      end
      it 'should create a gnu for the current combination' do
        put :update, :id => @node.id, :node => {'text' => 'some text', 'these' => 'params'}
        GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].should be_a(GlobalNodeUser)
      end

      it 'should increase gnu count by one' do
        expect {
          put :update, :id => @node.id, :node => {'text' => 'some text', 'these' => 'params'}
        }.to change(GlobalNodeUser, :count).by(2)
      end

      it 'should not increase gn count' do
        expect {
          put :update, :id => @node.id, :node => {'text' => 'some text', 'these' => 'params'}
        }.to change(GlobalNode, :count).by(1)
      end

      it 'should update is conclusion and xml for current gnu combination' do
        pending
      end

      it 'should update is conclusion and xml for current gn combination' do
        pending
      end

      it 'should assign the current gnu as gnu' do
        put :update, :id => @node.id, :node => {'text' => 'some text', 'these' => 'params'}
        assigns(:gnu).should be_a(GlobalNodeUser)
        assigns(:gnu).global.should eq(@global)
        assigns(:gnu).user.should eq(@user)
        assigns(:gnu).node.should eq(@node)
        pending
      end

      it 'should assign the current gn as gn' do
        put :update, :id => @node.id, :node => {'text' => 'some text', 'these' => 'params'}
        assigns(:gn).should be_a(GlobalNode)
        assigns(:gn).global.should eq(@global)
        assigns(:gn).node.should eq(@node)
      end

      it "assigns the requested node as @node" do
        put :update, :id => @node.id, :node => {'text' => 'some text', 'these' => 'params'}
        assigns(:gn).should be_a(GlobalNode)
        assigns(:gn).global.should eq(@global)
        assigns(:gn).node.should eq(@node)
      end

      it "redirects to the node" do
        node = Node.create! valid_attributes
        Node.stub(:find).and_return node
        put :update, :id => node.id, :node => valid_attributes
        response.should redirect_to node
      end
    end
    ### integration tests for two cases end###

    describe "with valid params for a new node global user combination and an existing node global other than all" do
      #just stub and test calls - no more integration tests - done 2 examples, don't need all in gnu spec
    end

    describe 'with an existing global node user but no global node' do
      #THIS SHOULD NEVER HAPPEN
    end

    describe "with invalid params" do
      it "assigns the node as @node" do
        node = Node.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Node.any_instance.stub(:save).and_return(false)
        put :update, :id => node.id, :node => {}
        assigns(:node).should eq(node)
      end

      it "re-renders the 'edit' template" do
        node = Node.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Node.any_instance.stub(:save).and_return(false)
        put :update, :id => node.id, :node => {}
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    context 'when no other users but current gnu/gn' do

      it "destroys the requested node" do
        node = Node.create! valid_attributes
        expect {
          delete :destroy, :id => node.id
        }.to change(Node, :count).by(-1)
      end

      it 'should destroy the gn' do
        pending
      end

      it 'should destroy the gnu' do
        pending
      end

      it 'should destroy the links scoped to this global and node and user (the links for the user - can not have inconsist links) (uglfs uglts lts lfs)' do
        pending
      end

    end

    context 'when other gns but only this user in this gn' do
      it 'should destroy the gn' do
        pending
      end

      it 'should destroy the gnu' do
        pending
      end

      it 'should destroy the links scoped to this global and node and user (the links for the user - can not have inconsist links) and to this global node (uglfs uglts)' do
        pending
      end

    end
    
    context 'when other gns, gnus is other gns and gnus in this gn' do
      it 'should only destroy whats scoped to the user - gnus uglfs and uglts' do

      end
    end

    it "redirects to the nodes list" do
      node = Node.create! valid_attributes
      delete :destroy, :id => node.id
      response.should redirect_to("/")
    end
  end


end
