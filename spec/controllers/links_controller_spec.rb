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
          controller.stub(:current_user).and_return @user_two
          @params = {"id"=>@link.id, "link"=>{"node_from"=>@node_one.id.to_s, "value"=>-1.to_s, "node_to"=>@node_two.id.to_s}}
        end
        #should change or create the user link - only 4 links with votes
        it 'should update the link' do
          pending
          Link.stub(:find).and_return @link
          @link.should_receive(:update_attributes).with(@params["link"]).and_return true
          #xhr :put, :update, @params
        end
        it 'should change the value and increment the caches' do
          pending
          @link.value.should == 1
          #xhr :put, :update, @params
          @link.reload
          @link.value.should == -1
        end
        it 'should render the links template for the updated link (into the same place on the page - untested)' do
          pending
          #xhr :put, :update, @params
          @link.reload
          response.should render_template(:partial => "_a_link")
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
