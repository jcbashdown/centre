require 'spec_helper'

describe LinksController do

  before do
    @global = Factory(:global)
    Global.stub(:find).and_return @global
  end
  # This should return the minimal set of attributes required to create a valid
  # Link. As you add validations to Link, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end
  
  describe 'permission to interact' do
    context 'when the user does not have permission to interact with this link' do

    end
    context 'when user has permission to interact with this link' do

    end
  end
  
  describe 'update' do
    before do
      @user = Factory(:user)
      controller.stub(:current_user).and_return @user
      @ugn1 = GlobalNodeUser.create(:user=>@user, :title=>'title', :global=>@global)
      @node_one = @ugn1.node
      @ugn2 = GlobalNodeUser.create(:user=>@user, :title=>'test', :global=>@global)
      @node_two = @ugn2.node
      @node_one = Factory(:node)
      @params_one = {"link"=>{"node_from_id"=>@node_one.id.to_s, "value"=>1.to_s, "node_to_id"=>@node_two.id.to_s}}
      @glu = GlobalLinkUser.new(@params_one["link"].merge(:global => @global, :user => @user))
    end
    #update will destroy and then create as too much logic for an after save if we check if we need to to destroy global links etc.
    context 'when ajax request' do
      context 'with valid params' do
        before do
          @params = {"link"=>{"node_from_id"=>@node_one.id.to_s, "value"=>-1.to_s, "node_to_id"=>@node_two.id.to_s}, "id" =>@glu.id}
          @mock_glu = mock('global_link_user')
          @mock_glu_2 = mock('global_link_user')
          @mock_link = mock('link')
          @mock_glu.stub(:save).and_return true
          @mock_glu.stub(:link).and_return @mock_link
          @mock_glu_2.stub(:destroy).and_return true
        end
        it 'should save the glu' do
          GlobalLinkUser.stub(:find).and_return @mock_link_2
          @mock_link.should_receive(:destroy)
          xhr :put, :update, @params
        end
        it 'should save the glu' do
          GlobalLinkUser.stub(:new).and_return @mock_link
          @mock_link.should_receive(:save)
          xhr :put, :update, @params
        end
        it 'increment the caches' do
          Link.where(@params["link"]).first.should be_nil
          link = Link.where(@params_one["link"]).first
          link.users_count.should == 1
          xhr :post, :create, @params
          link = Link.where(@params["link"]).first
          link.users_count.should == 1
          link = Link.where(@params_one["link"]).first
          link.users_count.should == 0 
        end
        it 'should render the link partial for the newly associated link (not tested)' do
          @mock_link.stub(:save).and_return true
          GlobalLinkUser.stub(:new).and_return(@mock_link)
          xhr :put, :update, @params
          response.should render_template(:partial => "_a_link")
        end
        it 'should assign the correct link' do
          put :update, @params
          new_link = GlobalLinkUser.where(@params["link"].merge(:user_id => @user.id, :global_id => @global.id)).first
          assigns(:gnu).should == new_link
        end
        it 'initialise a new link with the correct parameters' do
          GlobalLinkUser.should_receive(:new).with(@params["link"].merge("global" => @global, "user" => @user)).and_return @mock_link
          xhr :post, :create, @params
        end
      end
      context 'when destroy or save returns false for glu' do
        before do
          @params = {"link"=>{"node_from_id"=>@node_one.id.to_s, "node_to_id"=>@node_two.id.to_s}}
          @mock_link = mock('global_link_user')
          @mock_link.stub(:save).and_return false
        end
        it 'initialise a new link with the correct parameters' do
          GlobalLinkUser.should_receive(:new).twice.and_return @mock_link
          xhr :put, :update, @params
        end
        it 'should render the link template' do
          GlobalLinkUser.stub(:new).and_return @mock_link
          xhr :put, :update, @params
          response.should render_template(:partial => "_a_link")
        end
      end
    end
  end
  describe 'create' do
    before do
      @user = Factory(:user)
      controller.stub(:current_user).and_return @user
      @ugn1 = GlobalNodeUser.create(:user=>@user, :title=>'title', :global=>@global)
      @node_one = @ugn1.node
      @ugn2 = GlobalNodeUser.create(:user=>@user, :title=>'test', :global=>@global)
      @node_two = @ugn2.node
    end
    context 'when ajax request' do
      context 'with valid params' do
        before do
          @params = {"link"=>{"node_from_id"=>@node_one.id.to_s, "value"=>-1.to_s, "node_to_id"=>@node_two.id.to_s}}
          @mock_glu = mock('global_link_user')
          @mock_link = mock('link')
          @mock_glu.stub(:save).and_return true
          @mock_glu.stub(:link).and_return @mock_link
        end
        it 'should save the glu' do
          GlobalLinkUser.stub(:new).and_return @mock_glu
          @mock_glu.should_receive(:save)
          xhr :post, :create, @params
        end
        it 'increment the caches' do
          Link.where(@params["link"]).first.should be_nil
          xhr :post, :create, @params
          link = Link.where(@params["link"]).first
          link.users_count.should == 1
        end
        it 'should render the link partial for the newly associated link (not tested)' do
          @mock_glu.stub(:save).and_return true
          GlobalLinkUser.stub(:new).and_return(@mock_glu)
          xhr :post, :create, @params
          response.should render_template(:partial => "_a_link")
        end
        it 'should assign the correct link' do
          post :create, @params
          new_link = GlobalLinkUser.where(@params["link"].merge(:user_id => @user.id, :global_id => @global.id)).first
          assigns(:glu).should == new_link
        end
        it 'initialise a new link with the correct parameters' do
          GlobalLinkUser.should_receive(:new).with(@params["link"].merge("global" => @global, "user" => @user)).and_return @mock_glu
          xhr :post, :create, @params
        end
      end
      context 'when save returns false for glu' do
        before do
          @params = {"link"=>{"node_from_id"=>@node_one.id.to_s, "node_to_id"=>@node_two.id.to_s}}
          @mock_glu = mock('global_link_user')
          @mock_link = mock('link')
          @mock_glu.stub(:save).and_return false
          @mock_glu.stub(:link).and_return @mock_link
        end
        it 'initialise a new link with the correct parameters' do
          GlobalLinkUser.should_receive(:new).and_return @mock_glu
          Link.should_receive(:new).and_return @mock_link
          xhr :post, :create, @params
        end
        it 'should render the link template' do
          GlobalLinkUser.stub(:new).and_return @mock_glu
          xhr :post, :create, @params
          response.should render_template(:partial => "_a_link")
        end
      end
    end
  end
  describe 'destroy' do
    before do
      @node_one = Factory(:node)
      @node_two = Factory(:node, :title=>'title')
      @nodes_global1 = Factory(:nodes_global, :node=>@node_one, :global=>@global)
      @nodes_global2 = Factory(:nodes_global, :node=>@node_two, :global=>@global)
      @user = Factory(:user)
      @link = Link.create(:nodes_global_from=>@nodes_global1,:node_from=>@node_one,:nodes_global_to=>@nodes_global2,:node_to=>@node_two, :users=>[@user],:value=>1)
    end
    context 'when ajax request' do
      context 'with valid params' do
        before do
          @user_two = Factory(:user, :email=>'test@user.com', :password=>'123456AA')
          controller.stub(:current_user).and_return @user
          @params = {:id=>@link.id, :link=>{:node_from_id=>@node_one.id, :value=>1, :node_to_id=>@node_two.id}}
          @user_link = UserLink.where(:user_id=>@user.id, :link_id=>@link)
        end
        it 'should delete the link association' do
          UserLink.stub(:where).and_return [@user_link]
          @user_link.should_receive(:try).with(:destroy)
          xhr :post, :destroy, @params
        end
        it 'should save the old link' do
          Link.stub(:find).and_return @link
          @link.should_receive(:save!)
          xhr :post, :destroy, @params
        end
        it 'initialise a new link with the correct parameters' do
          Link.should_receive(:new).with({"node_from_id"=>@node_one.id.to_s, "node_to_id"=>@node_two.id.to_s})
          xhr :post, :destroy, @params
        end
        it 'should render the link template' do
          xhr :post, :destroy, @params
          response.should render_template(:partial => "_a_link")
        end
      end
    end
  end
end
