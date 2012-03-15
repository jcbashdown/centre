require 'spec_helper'

describe NodesController do
  before do
    @user = Factory(:user)
    controller.stub(:current_user).and_return @user
  end
  # This should return the minimal set of attributes required to create a valid
  # Node. As you add validations to Node, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {:title => 'title'}
  end

  describe "GET index" do
    it "assigns all nodes as @nodes" do
      node = Node.create! valid_attributes
      node.globals << Global.find_by_name('All')
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
        }.to change(GlobalNodeUser, :count).by(1)
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
    describe "with valid params for an existing node global user combination" do
      before do
        @gnu = GlobalsNodesUsers.create(:user=>@user, :node=>@node, :global=>Global.find_by_name('All'))
      end
      it "updates the requested node" do
        node = Node.create! valid_attributes
        # Assuming there are no other nodes in the database, this
        # specifies that the Node created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Node.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => node.id, :node => {'these' => 'params'}
      end

      it "assigns the requested node as @node" do
        node = Node.create! valid_attributes
        put :update, :id => node.id, :node => valid_attributes
        assigns(:node).should eq(node)
      end

      it "assigns the requested gnu as @gnu" do
        put :update, :id => node.id, :node => valid_attributes
        assigns(:node).should eq(@gnu)
      end

      it "redirects to the node" do
        node = Node.create! valid_attributes
        put :update, :id => node.id, :node => valid_attributes
        response.should redirect_to node
      end
    end
    describe "with valid params for a new node global user combination" do
      it "updates the requested node" do
        node = Node.create! valid_attributes
        # Assuming there are no other nodes in the database, this
        # specifies that the Node created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Node.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => node.id, :node => {'these' => 'params'}
      end

      it "assigns the requested node as @node" do
        node = Node.create! valid_attributes
        put :update, :id => node.id, :node => valid_attributes
        assigns(:node).should eq(node)
      end

      it "redirects to the node" do
        node = Node.create! valid_attributes
        put :update, :id => node.id, :node => valid_attributes
        response.should redirect_to node
      end
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
    it "destroys the requested node" do
      node = Node.create! valid_attributes
      expect {
        delete :destroy, :id => node.id
      }.to change(Node, :count).by(-1)
    end

    it "redirects to the nodes list" do
      node = Node.create! valid_attributes
      delete :destroy, :id => node.id
      response.should redirect_to("/")
    end
  end

end
