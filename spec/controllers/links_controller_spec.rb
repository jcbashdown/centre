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
  
  #This should really be userlinks controller
  describe 'update' do
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
          @params = {"id"=>@link.id, "link"=>{"node_from_id"=>@node_one.id.to_s, "value"=>-1.to_s, "node_to_id"=>@node_two.id.to_s}}
          @with_node_globals= {"id"=>@link.id, "link"=>{"node_from_id"=>@node_one.id.to_s, "value"=>-1.to_s, "node_to_id"=>@node_two.id.to_s,"nodes_global_from_id"=>@nodes_global1.id,"nodes_global_to_id"=>@nodes_global2.id}}
        end
        it 'should update the link association' do
          Link.stub(:find).and_return @link
          @user.should_receive(:update_association).with(@link, @with_node_globals["link"])
          xhr :put, :update, @params
        end
        it 'should change the value and increment the caches' do
          @node_two.reload
          @node_two.downvotes_count.should == 0
          @node_two.upvotes_count.should == 1
          Link.where(@with_node_globals["link"])[0].should be_nil
          @link.users_count.should == 1
          xhr :put, :update, @params
          @link.reload
          @link.users_count.should == 0
          Link.where(@with_node_globals["link"])[0].users_count.should == 1
          @node_two.reload
          @node_two.upvotes_count.should == 0
          @node_two.downvotes_count.should == 1
          @nodes_global2.reload
          @nodes_global2.upvotes_count.should == 0
          @nodes_global2.downvotes_count.should == 1
        end
        it 'should render the link partial for the newly associated link (not tested)' do
          xhr :put, :update, @params
          response.should render_template(:partial => "_a_link")
        end
        #doing this here as otherwise difficult to test returned by update assoc link:
        #can't test in partial
        it 'should assign the correct link' do
          put :update, @params
          new_link = Link.where(@with_node_globals["link"]).first
          assigns(:link).should == new_link
        end
      end
      #also get votes counts
      # what we are not speccing here is the returned partial
    end
  end
  describe 'create' do
    before do
      @user = Factory(:user)
      controller.stub(:current_user).and_return @user
      @node_one = Factory(:node)
      @node_two = Factory(:node, :title=>'title')
      @ugn1 = GlobalNodeUser.create(:user=>@user, :node=>@node_one, :global=>@global)
      @ugn2 = GlobalNodeUser.create(:user=>@user, :node=>@node_two, :global=>@global)
    end
    context 'when ajax request' do
      context 'with valid params' do
        before do
          @params = {"link"=>{"node_from_id"=>@node_one.id.to_s, "value"=>-1.to_s, "node_to_id"=>@node_two.id.to_s}}
          @unsaved_link = Link.new(@params["link"])
        end
        it 'should save the link' do
          Link.stub(:new).and_return @unsaved_link
          @unsaved_link.should_receive(:save)
          xhr :post, :create, @params
        end
        it 'should should save the the glu' do
          @saved_link = @unsaved_link
          @saved_link.save
          @glu_params = {:global => @global, :link_id => @saved_link.id, :user => @user, :node_from_id => @node_one.id, :node_to_id => @node_two.id}
          Link.stub(:new).and_return @saved_link
          GlobalLinkUser.should_receive(:create).with(@glu_params)
          xhr :post, :create, @params
        end
        it 'increment the caches' do
          Link.where(@params["link"]).first.should be_nil
          xhr :post, :create, @params
          link = Link.where(@params["link"]).first
          link.users_count.should == 1
        end
        it 'should render the link partial for the newly associated link (not tested)' do
          xhr :post, :create, @params
          response.should render_template(:partial => "_a_link")
        end
        #doing this here as otherwise difficult to test returned by update assoc link:
        #can't test in partial
        it 'should assign the correct link' do
          post :create, @params
          new_link = Link.where(@params["link"]).first
          assigns(:link).should == new_link
        end
      end
      context 'when save returns false for glu or link' do
        before do
          @params = {"link"=>{"node_from_id"=>@node_one.id.to_s, "node_to_id"=>@node_two.id.to_s}}
          @unsaved_link = Link.new(@params["link"])
          @unsaved_link.stub(:save).and_return false
        end
        it 'initialise a new link with the correct parameters' do
          Link.should_receive(:new).twice.with(@params["link"]).and_return @unsaved_link
          xhr :post, :create, @params
        end
        it 'should render the link template' do
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
