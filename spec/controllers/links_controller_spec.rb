require 'spec_helper'

describe LinksController do

  # This should return the minimal set of attributes required to create a valid
  # Link. As you add validations to Link, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end
  
  #This should really be userlinks controller
  describe 'update' do
    before do
      @node_one = Factory(:node)
      @node_two = Factory(:node, :title=>'title')
      @user = Factory(:user)
      @link = Link.create(:node_from=> @node_one, :value=>1, :node_to=>@node_two, :users=>[@user])
    end
    context 'when ajax request' do
      context 'with valid params' do
        before do
          @user_two = Factory(:user, :email=>'test@user.com', :password=>'123456AA')
          controller.stub(:current_user).and_return @user
          @params = {"id"=>@link.id, "link"=>{"node_from_id"=>@node_one.id.to_s, "value"=>-1.to_s, "node_to_id"=>@node_two.id.to_s}}
        end
        it 'should update the link association' do
          Link.stub(:find).and_return @link
          @user.should_receive(:update_association).with(@link, @params["link"])
          xhr :put, :update, @params
        end
        it 'should change the value and increment the caches' do
          @link.users_count.should == 1
          xhr :put, :update, @params
          @link.reload
          @link.users_count.should == 0
        end
        it 'should render the link partial for the newly associated link (not tested)' do
          xhr :put, :update, @params
          response.should render_template(:partial => "_a_link")
        end
        #doing this here as otherwise difficult to test returned by update assoc link:
        #can't test in partial
        it 'should assign the correct link' do
          put :update, @params
          new_link = Link.where(@params["link"]).first
          assigns(:link).should == new_link
        end
      end
      #also get votes counts
      # what we are not speccing here is the returned partial
    end
  end
  describe 'create' do
    before do
      @node_one = Factory(:node)
      @node_two = Factory(:node, :title=>'title')
      @user = Factory(:user)
    end
    context 'when ajax request' do
      context 'with valid params' do
        before do
          controller.stub(:current_user).and_return @user
          @params = {"link"=>{"node_from_id"=>@node_one.id.to_s, "value"=>-1.to_s, "node_to_id"=>@node_two.id.to_s}}
        end
        it 'should create the link association' do
          @user.should_receive(:create_association).with(@params["link"])
          xhr :post, :create, @params
        end
        it 'increment the caches' do
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
        context 'when create association returns false' do
          before do
            @user.stub(:create_association).and_return false
          end
          it 'initialise a new link with the correct parameters' do
            Link.should_receive(:new).with({"node_from_id"=>@node_one.id.to_s, "node_to_id"=>@node_two.id.to_s})
            xhr :post, :create, @params
          end
          it 'should render the link template' do
            xhr :post, :create, @params
            response.should render_template(:partial => "_a_link")
          end
        end
      end
      #also get votes counts
      # what we are not speccing here is the returned partial
    end
  end
  describe 'destroy' do
    before do
      @node_one = Factory(:node)
      @node_two = Factory(:node, :title=>'title')
      @user = Factory(:user)
      @link = Link.create(:node_from=> @node_one, :value=>1, :node_to=>@node_two, :users=>[@user])
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
