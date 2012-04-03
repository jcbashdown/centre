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
    {:title => 'title', :text => ''}
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
        }.to change(GlobalNodeUser, :count).by(1)
      end

      it "creates a new GlobalNode" do
        expect {
          post :create, :node => valid_attributes
        }.to change(GlobalNode, :count).by(1)
      end

      it 'should have called create on global node user' do
        gnu = GlobalNodeUser.new({:user => @user, :global => @global}.merge({"title" => 'title', "text" => ''}))
        GlobalNodeUser.should_receive(:new).with({:user => @user, :global => @global}.merge({"title" => 'title', "text" => ''})).and_return gnu
        post :create, :node => valid_attributes
      end

      it "assigns a newly created node as @node" do
        post :create, :node => valid_attributes
        assigns(:node).should be_a(Node)
        assigns(:gnu).should be_a(GlobalNodeUser)
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
        GlobalNodeUser.any_instance.stub(:save).and_return(false)
        post :create, :node => {}
        assigns(:gnu).should be_a_new(GlobalNodeUser)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        GlobalNodeUser.any_instance.stub(:save).and_return(false)
        post :create, :node => {}
        response.should render_template("new")
      end
    end
  end

#  describe "PUT update" do
#    before do
#      @node = Node.create! valid_attributes
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
      @node = Node.create! valid_attributes
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
