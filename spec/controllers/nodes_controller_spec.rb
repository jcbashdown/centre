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
  describe 'set_user_links' do
    context 'when there is a user' do
      before do
        @user_two = Factory(:user, :email=>'test@user.com', :password=>'123456AA')
        @node_one = Factory(:node, :title=>'aone1')
        @node_two = Factory(:node, :title=>'ctwo2')
        @node_three = Factory(:node, :title=>'bthree3')
        @link1=Link.create(:node_from=> @node_one, :value=>1, :node_to=>@node_two)
        @link1u2=Link.new(:node_from=> @node_one, :node_to=>@node_two)
        @link1.users << @user
        #node two activity is one
        @link2=Link.create(:node_from=> @node_one, :value=>1, :node_to=>@node_three)
        @link2.users << @user
        @link2.users << @user_two 
        #node three activity is two
        @link3=Link.create(:node_from=> @node_two, :value=>1, :node_to=>@node_one)
        @link3u2=Link.new(:node_from=> @node_two, :node_to=>@node_one)
        @link3.users << @user
        #node one activity is one
        @link4=Link.new(:node_from=> @node_two, :node_to=>@node_three)
        @link5=Link.new(:node_from=> @node_three, :node_to=>@node_one)
        @link6=Link.create(:node_from=> @node_three, :value=>-1, :node_to=>@node_two)
        @link6.users << @user
        @link6.users << @user_two 
        #node two activity is three
        #for user = @user
        @user_links_out_alph_up_for_node_one = [@link2,
                                                @link1]
        @user_links_out_alph_down_for_node_one = [@link1,
                                                  @link2]
        #all votes count for node count
        @user_links_out_active_for_node_one = [@link1,
                                               @link2]
        @user_links_out_inactive_for_node_one = [@link2,
                                                 @link1]
        @user_links_out_alph_up_for_node_two = [@link3,
                                                @link4]
        @user_links_out_alph_down_for_node_two = [@link4,
                                                  @link3]
        #all votes count for node count
        @user_links_out_active_for_node_two = [@link4,
                                               @link3]
        @user_links_out_inactive_for_node_two = [@link3,
                                                 @link4]
        #for user = @user_two
        @user2_links_out_alph_up_for_node_one = [@link2,
                                                 @link1u2]
        @user2_links_out_alph_down_for_node_one = [@link1u2,
                                                   @link2]
        #all votes count for node count
        @user2_links_out_active_for_node_one = [@link1u2,
                                                @link2]
        @user2_links_out_inactive_for_node_one = [@link2,
                                                  @link1u2]
        @user2_links_out_alph_up_for_node_two = [@link3u2,
                                                 @link4]
        @user2_links_out_alph_down_for_node_two = [@link4,
                                                   @link3u2]
        #all votes count for node count
        @user2_links_out_active_for_node_two = [@link4,
                                                @link3u2]
        @user2_links_out_inactive_for_node_two = [@link3u2,
                                                  @link4]
      end
      #set user links can happen here but method it calls - specs should be moved to user
      it 'should return the user links for @user from @node_one and construct those not present in alphabet order as default' do
        @user.user_from_node_links(@node_one).inspect.should == @user_links_out_alph_up_for_node_one.inspect
      end
      it 'should return the user links for @user_two from @node_one and construct those not present in alphabet order as default' do
        @user_two.user_from_node_links(@node_one).inspect.should == @user2_links_out_alph_up_for_node_one.inspect
      end
      it 'should return the user links for @user from @node_two and construct those not present in alphabet order as default' do
        @user.user_from_node_links(@node_two).inspect.should == @user_links_out_alph_up_for_node_two.inspect
      end
      it 'should return the user links for @user_two from @node_two and construct those not present in alphabet order as default' do
        @user_two.user_from_node_links(@node_two).inspect.should == @user2_links_out_alph_up_for_node_two.inspect
      end
    end
    context 'links in for node' do
      before do
        @user_two = Factory(:user, :email=>'test@user.com', :password=>'123456AA')
        @node_one = Factory(:node, :title=>'aone1')
        @node_two = Factory(:node, :title=>'ctwo2')
        @node_three = Factory(:node, :title=>'bthree3')
        @link1=Link.create(:node_from=> @node_one, :value=>1, :node_to=>@node_two)
        @link1u2=Link.new(:node_from=> @node_one, :node_to=>@node_two)
        @link1.users << @user
        #node two activity is one
        @link2=Link.create(:node_from=> @node_one, :value=>1, :node_to=>@node_three)
        @link2.users << @user
        @link2.users << @user_two 
        #node three activity is two
        @link3=Link.create(:node_from=> @node_two, :value=>1, :node_to=>@node_one)
        @link3u2=Link.new(:node_from=> @node_two, :node_to=>@node_one)
        @link3.users << @user
        #node one activity is one
        @link4=Link.new(:node_from=> @node_two, :node_to=>@node_three)
        @link5=Link.new(:node_from=> @node_three, :node_to=>@node_one)
        @link6=Link.create(:node_from=> @node_three, :value=>-1, :node_to=>@node_two)
        @link6.users << @user
        @link6.users << @user_two 
        #node two activity is three
        #for user = @user
        @user_links_in_alph_up_for_node_one = [@link5,
                                                @link3]
        @user_links_in_alph_down_for_node_one = [@link3,
                                                  @link5]
        @user_links_in_alph_up_for_node_two = [@link1,
                                                @link6]
        @user_links_in_alph_down_for_node_two = [@link6,
                                                  @link1]
        @user2_links_in_alph_up_for_node_one = [@link5,
                                                @link3u2]
        @user2_links_in_alph_down_for_node_one = [@link5,
                                                  @link3u2]
        @user2_links_in_alph_up_for_node_two = [@link1u2,
                                                @link6]
        @user2_links_in_alph_down_for_node_two = [@link6u2,
                                                  @link1]
      end
      it 'should return the user links for @user from @node_one and construct those not present in alphabet order as default' do
        @user.user_to_node_links(@node_one).inspect.should == @user_links_in_alph_up_for_node_one.inspect
      end
      it 'should return the user links for @user_two from @node_one and construct those not present in alphabet order as default' do
        @user_two.user_to_node_links(@node_one).inspect.should == @user2_links_in_alph_up_for_node_one.inspect
      end
      it 'should return the user links for @user from @node_two and construct those not present in alphabet order as default' do
        @user.user_to_node_links(@node_two).inspect.should == @user_links_in_alph_up_for_node_two.inspect
      end
      it 'should return the user links for @user_two from @node_two and construct those not present in alphabet order as default' do
        @user_two.user_to_node_links(@node_two).inspect.should == @user2_links_in_alph_up_for_node_two.inspect
      end
    end
  end

  describe "GET index" do
    it "assigns all nodes as @nodes" do
      node = Node.create! valid_attributes
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

      it "assigns a newly created node as @node" do
        post :create, :node => valid_attributes
        assigns(:node).should be_a(Node)
        assigns(:node).should be_persisted
      end

      it "assigns the node to the current user" do
        post :create, :node => valid_attributes
        node = Node.last
        node.user.should == @user
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
    describe "with valid params" do
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
