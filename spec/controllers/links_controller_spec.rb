require 'spec_helper'

describe LinksController do

  before do
    @question = FactoryGirl.create(:question)
    Question.stub(:find).and_return @question
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
      @user = FactoryGirl.create(:user)
      controller.stub(:current_user).and_return @user
      @cn1 = ContextNode.create(:user=>@user, :title=>'title', :question=>@question)
      @node_one = @cn1.global_node
      @cn2 = ContextNode.create(:user=>@user, :title=>'test', :question=>@question)
      @node_two = @cn2.global_node
      @params_one = {"link"=>{"node_from_id"=>@node_one.id.to_s, "value"=>1.to_s, "node_to_id"=>@node_two.id.to_s}}
      @context_link = ContextLink.create(@params_one["link"].merge(:question => @question, :user => @user))
      @user_two = FactoryGirl.create(:user, :email => "user2@test.com")
      @context_linkser2 = ContextLink.create(@params_one["link"].merge(:question => @question, :user => @user_two))
    end
    #update will destroy and then create as too much logic for an after save if we check if we need to to destroy question links etc.
    context 'when ajax request' do
      context 'with valid params' do
        before do
          @params = {"link"=>{"node_from_id"=>@node_one.id.to_s, "value"=>-1.to_s, "node_to_id"=>@node_two.id.to_s}, "id" =>@context_link.global_link.id, "question" => @question.id}
          @mock_cn = mock('context_link')
          @mock_cn_2 = mock('context_link')
          @mock_global_link = mock('global_link')
          @mock_cn_2.stub(:save).and_return true
          @mock_cn_2.stub(:link).and_return @mock_global_link
          @mock_cn.stub(:destroy).and_return true
          @mock_relation = mock('relation')
        end
        it 'should destroy the glu' do
          @mock_relation.stub(:where).and_return [@mock_cn]
          ContextLink.stub(:with_all_associations).and_return @mock_relation
          @mock_cn.should_receive(:destroy)
          xhr :put, :update, @params
        end
        it 'should save the glu' do
          ContextLink.stub(:find).and_return @mock_cn
          ContextLink.stub(:new).and_return @mock_cn_2
          @mock_cn_2.should_receive(:save)
          xhr :put, :update, @params
        end
        it 'increment the caches' do
          GlobalLink.where(@params["link"]).first.should be_nil
          global_link = GlobalLink.where(@params_one["link"]).first
          global_link.users_count.should == 2
          UserLink.count.should == 2
          xhr :post, :update, @params
          global_link = GlobalLink.where(@params["link"]).first
          global_link.users_count.should == 1
          global_link.users_count.should == 1
          global_link = GlobalLink.where(@params_one["link"]).first
          global_link.users_count.should == 1
          global_link.users_count.should == 1
        end
        it 'should render the link partial for the newly associated link (not tested)' do
          xhr :put, :update, @params
          response.should render_template(:partial => "_a_link")
        end
        it 'should assign the correct link' do
          put :update, @params
          new_link = ContextLink.where(@params["link"].merge(:user_id => @user.id, :question_id => @question.id)).first
          assigns(:glu).should == new_link
        end
        it 'should create a link with the correct parameters' do
          @context_link = ContextLink.create(@params["link"].merge("question" => @question, "user" => @user))
          ContextLink.should_receive(:create).with(@params["link"].merge("question" => @question, "user" => @user)).and_return @context_link
          xhr :post, :update, @params
        end
      end
      context 'when destroy or save returns false for glu' do
        before do
          @params = {"link"=>{"node_from_id"=>@node_one.id.to_s, "value"=>-1.to_s, "node_to_id"=>@node_two.id.to_s}, "id" =>@context_link.global_link.id, :question => @question.id}
          @new_link_params = {"link"=>{"node_from_id"=>@node_one.id.to_s, "node_to_id"=>@node_two.id.to_s}}
          ContextLink.stub(:create).and_return false
        end
        context 'when glu destroyed but nothing new created' do
          it 'initialise a new link with the correct parameters' do
            Link.should_receive(:new).with(@new_link_params["link"])
            xhr :put, :update, @params
          end
        end
        it 'should render the link template' do
          xhr :put, :update, @params
          response.should render_template(:partial => "_a_link")
        end
      end
    end
  end
  describe 'create' do
    before do
      @user = FactoryGirl.create(:user)
      controller.stub(:current_user).and_return @user
      @cn1 = ContextNode.create(:user=>@user, :title=>'title', :question=>@question)
      @node_one = @cn1.node
      @cn2 = ContextNode.create(:user=>@user, :title=>'test', :question=>@question)
      @node_two = @cn2.node
    end
    context 'when ajax request' do
      context 'with valid params' do
        before do
          @params = {"link"=>{"node_from_id"=>@node_one.id.to_s, "value"=>-1.to_s, "node_to_id"=>@node_two.id.to_s}, "question" => @question.id}
          @mock_glu = mock('context_link')
          @mock_link = mock('link')
          @mock_glu.stub(:save).and_return true
          @mock_glu.stub(:link).and_return @mock_link
        end
        it 'should save the glu' do
          ContextLink.stub(:new).and_return @mock_glu
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
          ContextLink.stub(:new).and_return(@mock_glu)
          xhr :post, :create, @params
          response.should render_template(:partial => "_a_link")
        end
        it 'should assign the correct link' do
          post :create, @params
          new_link = ContextLink.where(@params["link"].merge(:user_id => @user.id, :question_id => @question.id)).first
          assigns(:glu).should == new_link
        end
        it 'initialise a new link with the correct parameters' do
          ContextLink.should_receive(:new).with(@params["link"].merge("question" => @question, "user" => @user)).and_return @mock_glu
          xhr :post, :create, @params
        end
      end
      context 'when save returns false for glu' do
        before do
          @params = {"link"=>{"node_from_id"=>@node_one.id.to_s, "node_to_id"=>@node_two.id.to_s}}
          @mock_glu = mock('context_link')
          @mock_link = mock('link')
          @mock_glu.stub(:save).and_return false
          @mock_glu.stub(:link).and_return @mock_link
        end
        it 'initialise a new link with the correct parameters' do
          ContextLink.should_receive(:new).and_return @mock_glu
          Link.should_receive(:new).and_return @mock_link
          xhr :post, :create, @params
        end
        it 'should render the link template' do
          ContextLink.stub(:new).and_return @mock_glu
          xhr :post, :create, @params
          response.should render_template(:partial => "_a_link")
        end
      end
    end
  end
  describe 'destroy' do
    before do
      @user = FactoryGirl.create(:user)
      controller.stub(:current_user).and_return @user
      @cn1 = ContextNode.create(:user=>@user, :title=>'title', :question=>@question)
      @node_one = @cn1.node
      @cn2 = ContextNode.create(:user=>@user, :title=>'test', :question=>@question)
      @node_two = @cn2.node
      @params_one = {"link"=>{"node_from_id"=>@node_one.id.to_s, "value"=>1.to_s, "node_to_id"=>@node_two.id.to_s}}
      @context_link = ContextLink.create(@params_one["link"].merge(:question => @question, :user => @user))
      @user_two = FactoryGirl.create(:user, :email => "user2@test.com")
      @context_linkser2 = ContextLink.create!(@params_one["link"].merge(:question => @question, :user => @user_two))
      @params_one = {"link"=>{"node_from_id"=>@node_one.id.to_s, "value"=>1.to_s, "node_to_id"=>@node_two.id.to_s}, :id => @context_link.global_link.id, :question => @question.id}
      @context_link.global_link.should == @gluser2.link
    end
    #update will destroy and then create as too much logic for an after save if we check if we need to to destroy question links etc.
    context 'when ajax request' do
      context 'with valid params' do
        before do
          @mock_glu = mock('context_link')
          @mock_glu_2 = mock('context_link')
          @mock_link = mock('link')
          @mock_glu_2.stub(:save).and_return true
          @mock_glu_2.stub(:link).and_return @mock_link
          @mock_glu.stub(:destroy).and_return true
          @mock_relation = mock('relation')
        end
        it 'should save the glu' do
          @mock_relation.stub(:where).and_return [@mock_glu]
          ContextLink.stub(:with_all_associations).and_return @mock_relation
          @mock_glu.should_receive(:destroy)
          xhr :put, :destroy, @params_one
        end
        it 'decrement the caches' do
          link = Link.where(@params_one["link"]).first
          link.should_not be_nil
          link.reload.users_count.should == 2
          link.users_count.should == 2 
          xhr :post, :destroy, @params_one
          link = Link.where(@params_one["link"]).first
          link.users_count.should == 1
          link.users_count.should == 1
        end
        it 'should render the link partial for the newly associated link (not tested)' do
          xhr :put, :destroy, @params_one
          response.should render_template(:partial => "_a_link")
        end
        it 'should assign the correct link' do
          @new_link_params = {"link"=>{"node_from_id"=>@node_one.id.to_s, "node_to_id"=>@node_two.id.to_s}}
          new_link = ContextLink.new(@new_link_params["link"])
          Link.should_receive(:new).with(@new_link_params["link"]).and_return new_link
          xhr :put, :destroy, @params_one
        end
      end
      context 'when destroy or save returns false for glu' do
        before do
          @context_link.stub(:destroy).and_return false
          ContextLink.stub(:find).and_return @context_link
        end
        it 'should render the link template' do
          xhr :put, :destroy, @params_one
          response.should render_template(:partial => "_a_link")
        end
      end
    end
  end
end
