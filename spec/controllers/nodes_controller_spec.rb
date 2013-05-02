require 'spec_helper'
require 'controllers/application_controller_spec_helper'

describe NodesController do
  before do
    @user = FactoryGirl.create(:user)
    controller.stub(:current_user).and_return @user
  end

  def valid_attributes
    {:node => {:title => 'title'}, :view_configuration => {:nodes_question => @question.try(:id)}}
  end
  
#  describe 'set nodes' do
#    before do
#      controller.stub(:show)
#      controller.stub(:set_node)
#      controller.stub(:set_links)
#    end
#    context 'when the global is all' do
#      before do
#        @params = {:question => @all_global.id}
#        Global.stub(:find).and_return @all_global
#      end
#      context 'when there is a find parameter' do
#        before do
#          question_id = nil
#          @params = @params.merge({:find => 'node name'})
#          @mock_results = Node.search do
#                            fulltext 'node name'
#                            with :global_id, question_id if question_id
#                            order_by(:id, :asc)
#                            paginate(:page => 1, :per_page => 5)
#                          end
#        end
#        it 'call search on node class' do
#          @mock_results.should_receive(:results)
#          Node.should_receive(:search).and_return @mock_results
#          get :show, @params
#        end
#      end
#      context 'when there is not find parameter' do
#        before do
#          @nodes = Node.order('id desc')
#          Node.stub(:order).and_return @nodes
#        end
#        it 'should call order on node' do
#          @nodes.should_receive(:paginate)
#          Node.should_receive(:order).and_return @nodes
#          get :show, @params
#        end
#      end
#    end
#    context 'when global is not all' do
#      before do
#        @params = {:question => @global.id}
#        @nodes = @global.nodes
#        @global.stub(:nodes).and_return @nodes
#        Global.stub(:find).and_return @global
#      end
#      context 'when there is a find parameter' do
#        before do
#          @params = @params.merge({:find => 'node name'})
#          @mock_results = mock('results')
#          @mock_results.stub(:results)
#        end
#        it 'call search on GlobalNode class' do
#          GlobalNode.should_receive(:search).and_return @mock_results
#          get :show, @params
#        end
#      end
#      context 'when there is not find parameter' do
#        it 'should call global nodes on the global' do
#          @global.should_receive(:nodes).and_return @nodes
#          get :show, @params
#        end
#      end
#    end
#  end
#
#  describe "GET index" do
#    context 'when there is no search term' do
#      it "assigns all nodes as @global_nodes for the current global" do
#        @gnu1 = GlobalNodeUser.create!(:user=>@user, :global=>@global, :title => 'Aardvark Anecdote Awkward About', :body => '')
#        node = @gnu1.node
#        get :index, :question => @global.id
#        assigns(:nodes).should eq([node])
#      end
#      it 'should assign node' do
#        get :index, :question => @global.id
#        assigns(:new_node).should be_a(Node)
#        assigns(:new_node).should_not be_persisted
#      end
#    end
#    context 'when there is a search term' do
#      before do
#        @gnu1 = GlobalNodeUser.create!(:user=>@user, :global=>@global, :title => 'Aardvark Anecdote Awkward About', :body => '')
#        @gnu2 = GlobalNodeUser.create!(:user=>@user, :global=>@global, :title => 'Aardvark', :body => 'blargh')
#        @gnu3 = GlobalNodeUser.create!(:user=>@user, :global=>@global, :title => 'Anecdote Awkward About', :body => '')
#        GlobalNode.reindex
#        @term = 'Aardvark'
#      end
#      it "assigns all nodes as @global_nodes for the current global" do
#        get :index, :question => @global.id, :find => @term
#        assigns(:nodes).should eq([@gnu1.global_node, @gnu2.global_node])
#      end
#
#    end
#  end
#
#  describe "GET show" do
#    before do
#      global_node_user = GlobalNodeUser.create!({:user=>@user, :global=>@global}.merge(valid_attributes))
#      @node_one = global_node_user.node 
#      @node_one = global_node_user.node 
#      @params = {:id=>@node_one.id, :question => @global.id}
#      controller.stub(:set_links)
#    end
#    it 'should assign node' do
#      get :show, @params
#      assigns(:new_node).should be_a(Node)
#      assigns(:new_node).should_not be_persisted
#    end
#    it "assigns all nodes as @global_nodes for the current global" do
#      get :show, @params
#      assigns(:nodes).should eq([@node_one])
#    end
#    context 'when node is node one' do
#      it 'should call set_node' do
#        controller.stub(:show)
#        controller.should_receive(:set_node)
#        get :show, @params
#      end
#      it 'should call set_node' do
#        get :show, @params
#        assigns(:node).should == @node_one
#      end
#      it 'should set user links' do
#        controller.should_receive(:set_links)
#        get :show, @params
#      end
#      context 'when set_links is unstubbed' do
#        before do
#          controller.unstub!(:set_links)
#        end
#        it 'should set user links' do
#          @user.should_receive(:user_from_node_links)
#          @user.should_receive(:user_to_node_links)
#          get :show, @params
#        end
#      end
#    end
#    context 'when there is a search term' do
#      before do
#        @gnu1 = GlobalNodeUser.create!(:user=>@user, :global=>@global, :title => 'Aardvark Anecdote Awkward About', :body => '')
#        @gnu2 = GlobalNodeUser.create!(:user=>@user, :global=>@global, :title => 'Aardvark', :body => 'blargh')
#        @gnu3 = GlobalNodeUser.create!(:user=>@user, :global=>@global, :title => 'Anecdote Awkward About', :body => '')
#        GlobalNode.reindex
#        @term = 'Aardvark'
#      end
#      it "assigns all nodes as @global_nodes for the current global" do
#        get :show, :question => @global.id, :find => @term, :id => @gnu1.node.id
#        assigns(:nodes).should eq([@gnu1.global_node, @gnu2.global_node])
#      end
#    end
#  end

  describe "POST create" do
    describe "with no question" do
      before do
        @question = nil
      end
      it "creates a new ContextNode" do
        expect {
          post :create, valid_attributes
        }.to change(ContextNode, :count).by(1)
      end

      it "creates a new GlobalNode" do
        expect {
          post :create, valid_attributes
        }.to change(Node::GlobalNode, :count).by(1)
      end

      it 'should have called new on global node user' do
        gnu = Node::UserNode.new({:user_id => @user.id, :title => 'title'})
        Node::UserNode.should_receive(:new).with({:user_id => @user.id, :question_id => nil, 'title' => 'title'}).and_return gnu
        post :create, valid_attributes
      end

      it "assigns a newly created correct context node as @node" do
        post :create, valid_attributes
        assigns(:node).should be_a(Node::GlobalNode)
      end

      it "redirects to the created node" do
        post :create, valid_attributes
        response.should redirect_to node_path(assigns(:node))
      end
    end
    describe "with question" do
      before do
        @question = FactoryGirl.create(:question)
        Question.stub(:find).and_return @question
      end
      it "creates a new GlobalNodeUser" do
        expect {
          post :create, valid_attributes
        }.to change(ContextNode, :count).by(1)
      end

      it "creates a new Node" do
        expect {
          post :create, valid_attributes
        }.to change(Node::GlobalNode, :count).by(1)
      end

      it 'should have called new on global node user' do
        gnu = Node::UserNode.new({:user_id => @user.id, :title => 'title'})
        Node::UserNode.should_receive(:new).with({:user_id => @user.id, :question_id => @question.id, 'title' => 'title'}).and_return gnu
        post :create, valid_attributes
      end

      it "assigns a newly created correct context nodes global node as @node" do
        post :create, valid_attributes
        assigns(:node).should be_a(Node::GlobalNode)
      end

      it "redirects to the created node" do
        post :create, valid_attributes
        response.should redirect_to node_path(assigns(:node))
      end
    end

    describe "with invalid params" do
      context 'when the node already exists' do
        before do
          @context_node = Node::UserNode.create!(:user => @user, :title => 'a test node')
        end
        it 'should redirect to show the node' do
          post :create, :node => {:title => 'a test node'}
          response.should redirect_to node_path(@context_node.global_node)
        end
        it "creates a new context node" do
          expect {
            post :create, :node => {:title => 'a test node'}
          }.to change(ContextNode, :count).by(0)
        end
      end
      it "assigns a newly created but unsaved node as @node" do
        Node::UserNode.stub(:create).and_return(false)
        post :create, :node => {}
        response.should redirect_to nodes_path
      end
    end
  end
  
  describe 'PUT update' do
    before do
      @user_node = Node::UserNode.create(title: 'Test', user: @user, question: @question)
      @context_node = ContextNode.where(user_node_id:@user_node.id, question_id:@question.try(:id))[0]
      @global_node_id = @context_node.global_node_id
      @question_id = @context_node.question_id
      @user_id = @context_node.user_id
      controller.stub(:current_user).and_return @context_node.user
      ContextNode.stub(:where).and_return [@context_node]
      Node::GlobalNode.stub(:find).and_return @context_node.global_node
    end
    let(:is_conclusion) {false}
    let(:params) {{:id => @global_node_id, :node => {:is_conclusion => is_conclusion}, :view_configuration => {:nodes_question => @question_id}}}

    it "should find the correct global_node for id" do
      Node.should_receive(:find).with(@global_node_id.to_s)
      xhr :put, :update, params
    end
    
    it 'should assign the global_node' do
      xhr :put, :update, params
      assigns(:node).should == @context_node.global_node
    end

    it 'should find the correct context node' do
      ContextNode.should_receive(:where).with(:question_id => @question_id, :user_node_id => @user_node.id)
      xhr :put, :update, params
    end

    context "when is conclusion is false" do
      it 'should call set_conclusion! with the is_conclusion status' do
        @context_node.should_receive(:set_conclusion!).with(is_conclusion)
        xhr :put, :update, params
      end
    end
    
    context "when is conclusion is ''" do
      let(:is_conclusion) {''}
      before {params[:node][:is_conclusion] = is_conclusion}
      it 'should call set_conclusion! with the is_conclusion status' do
        @context_node.should_receive(:set_conclusion!).with(is_conclusion)
        xhr :put, :update, params
      end
    end
    
  end

  describe "DELETE destroy" do
    context 'when there is a question' do
      before do
        @question = FactoryGirl.create(:question)
        Question.stub(:find).and_return @question
        @user_node = Node::UserNode.create(:user=>@user, :title => 'Title', :question => @question)
        @context_node = ContextNode.where(:user_node_id=>@user_node.id, :question_id => @question.try(:id))[0]
        mock_relation = mock('relation')
        ContextNode.stub(:where).and_return [@context_node]
      end
  
      it 'should call destroy on the current gnu' do
        @context_node.should_receive(:destroy)
        delete :destroy, :id => @context_node.global_node_id
      end
  
      it "redirects to the nodes list" do
        @context_node.stub(:destroy)
        delete :destroy, :id => @context_node.global_node_id
        response.should redirect_to nodes_path
      end
    end
    context 'when there is no question' do
      before do
        @question = FactoryGirl.create(:question)
        @user_node = Node::UserNode.create(:user=>@user, :title => 'Title', :question => @question)
        @context_node = ContextNode.where(:user_node_id=>@user_node.id, :question_id => @question.try(:id))[0]
        mock_relation = mock('relation')
        ContextNode.stub(:where).and_return [@context_node]
      end
  
      it 'should call destroy on the current gnu' do
        @context_node.should_receive(:destroy)
        delete :destroy, :id => @context_node.global_node_id
      end
  
      it "redirects to the nodes list" do
        @context_node.stub(:destroy)
        delete :destroy, :id => @context_node.global_node_id
        response.should redirect_to nodes_path
      end

    end
  end
  describe 'setting view resources' do
    before do
      @question = FactoryGirl.create(:question)
      @query = "Part of a node title"
    end
    describe 'setting links' do
      before do
        @current_node = mock('node')
        @current_node.stub(:id)
        @current_node.stub(:find_view_links_from_by_context)
        @current_node.stub(:find_view_links_to_by_context)
        Node.stub(:find).and_return @current_node
        Node::UserNode.stub(:where).and_return [stub(id:nil)]
      end
      describe 'set_links_to and from' do
        let(:action) {:show}
        it_should_behave_like 'a controller setting links for the view', "link", nil
        it_should_behave_like 'a controller setting links for the view', "link", "3"
      end
    end
  end

end
