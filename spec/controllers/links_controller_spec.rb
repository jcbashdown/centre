require 'spec_helper'

describe LinksController do

  # This should return the minimal set of attributes required to create a valid
  # Link. As you add validations to Link, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

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
          @user.should_receive(:update_association).with(@link, @params["link"]).and_return true
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
      #get all node for page ordered by link params, if exists for user get otherwise new, get votes count separately - make sure onlythree of each node then user counts
      #deal with current user and update if new - don't create for each user
      # what we are speccing here us the returned partial
    end

  end
  describe 'create' do
    context 'when ajax request' do
      before do
        controller.stub(:xhr?).and_return true
      end

    end

  end
  describe 'destroy' do
    context 'when ajax request' do
      before do
        controller.stub(:xhr?).and_return true
      end

    end
  end
end
