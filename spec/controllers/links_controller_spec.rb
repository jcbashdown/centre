require 'spec_helper'

describe LinksController do

  before do
    @question = FactoryGirl.create(:question)
    Question.stub(:find).and_return @question
  end
  
  describe 'update' do
    before do
      @user = FactoryGirl.create(:user)
      controller.stub(:current_user).and_return @user
      @cn1 = ContextNode.create(:user=>@user, :title=>'title', :question=>@question)
      @node_one = @cn1.global_node
      @cn2 = ContextNode.create(:user=>@user, :title=>'test', :question=>@question)
      @node_two = @cn2.global_node
      @params_one = {"type" => "Positive", "global_link"=>{"global_node_from_id"=>@node_one.id.to_s, "global_node_to_id"=>@node_two.id.to_s}}
      @context_link = ContextLink::PositiveContextLink.create(@params_one["global_link"].merge(:question => @question, :user => @user))
      @user_two = FactoryGirl.create(:user, :email => "user2@test.com")
      @context_linkuser2 = ContextLink::PositiveContextLink.create(@params_one["global_link"].merge(:question => @question, :user => @user_two))
    end
    #update will destroy and then create as too much logic for an after save if we check if we need to to destroy question links etc.
    context 'when ajax request' do
      context 'with valid params' do
        before do
          @params = {"type" => "Negative", "global_link"=>{"global_node_from_id"=>@node_one.id.to_s, "global_node_to_id"=>@node_two.id.to_s}, "id" =>@context_link.global_link.id, "view_configuration" => {"links_from_question" => @question.id}}
          @mock_cn = mock('context_link')
          @mock_cn_2 = mock('context_link')
          @mock_global_link = mock('global_link')
          @mock_cn_2.stub(:save).and_return true
          @mock_cn_2.stub(:global_link).and_return @mock_global_link
          @mock_cn.stub(:destroy).and_return true
          @mock_relation = mock('relation')
        end
        it 'should destroy the glu' do
          @mock_relation.stub(:where).and_return [@mock_cn]
          ContextLink.stub(:with_all_associations).and_return @mock_relation
          @mock_cn.should_receive(:update_type)
          xhr :put, :update, @params
        end
        it 'should save the glu' do
          ContextLink::NegativeContextLink.stub(:find).and_return @mock_cn
          ContextLink::NegativeContextLink.stub(:new).and_return @mock_cn_2
          @mock_cn_2.should_receive(:save)
          xhr :put, :update, @params
        end
        it 'increment the caches' do
          Link::GlobalLink::NegativeGlobalLink.where(:node_from_id => @params["global_link"]["global_node_from_id"], :node_to_id => @params["global_link"]["global_node_to_id"]).first.should be_nil
          global_link = Link::GlobalLink::PositiveGlobalLink.where(:node_from_id => @params_one["global_link"]["global_node_from_id"], :node_to_id => @params_one["global_link"]["global_node_to_id"]).first
          global_link.users_count.should == 2
          Link::UserLink.count.should == 2
          xhr :post, :update, @params
          global_link = Link::GlobalLink::NegativeGlobalLink.where(:node_from_id => @params["global_link"]["global_node_from_id"], :node_to_id => @params["global_link"]["global_node_to_id"]).first
          global_link.users_count.should == 1
          global_link = Link::GlobalLink::PositiveGlobalLink.where(:node_from_id => @params_one["global_link"]["global_node_from_id"], :node_to_id => @params_one["global_link"]["global_node_to_id"]).first
          global_link.users_count.should == 1
        end
        it 'should render the link partial for the newly associated link (not tested)' do
          xhr :put, :update, @params
          response.should render_template(:partial => "_a_link")
        end
        it 'should assign the correct link' do
          put :update, @params
          new_link = ContextLink.where(@params["global_link"].merge(:user_id => @user.id, :question_id => @question.id)).first
          assigns(:context_link).should == new_link
        end
        it 'should create a link with the correct parameters' do
          @mock_cn.should_receive(:update_type).with @params["type"]
          @mock_relation.stub(:where).and_return [@mock_cn]
          ContextLink.stub(:with_all_associations).and_return @mock_relation
          xhr :post, :update, @params
        end
      end
      context 'when destroy or save returns false for glu' do
        before do
          @params = {"type" => "Negative", "global_link"=>{"global_node_from_id"=>@node_one.id.to_s, "global_node_to_id"=>@node_two.id.to_s}, "id" =>@context_link.global_link.id, "view_configuration" => {"links_from_question" => @question.id}}
          @new_link_params = {"global_link"=>{:node_from_id=>@node_one.id.to_s, :node_to_id=>@node_two.id.to_s}}
          ContextLink::NegativeContextLink.stub(:create).and_return false
        end
        context 'when glu destroyed but nothing new created' do
          it 'initialise a new link with the correct parameters' do
            Link::GlobalLink.should_receive(:new).with(@new_link_params["global_link"])
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
      @node_one = @cn1.global_node
      @cn2 = ContextNode.create(:user=>@user, :title=>'test', :question=>@question)
      @node_two = @cn2.global_node
    end
    context 'when ajax request' do
      context 'with valid params' do
        before do
          @params = {"type" => "Negative", "global_link"=>{"global_node_from_id"=>@node_one.id.to_s, "global_node_to_id"=>@node_two.id.to_s}, "view_configuration" => {"links_from_question" => @question.id}}
          @mock_cl = mock('context_link')
          @mock_global_link = mock('global_link')
          @mock_cl.stub(:save).and_return true
          @mock_cl.stub(:global_link).and_return @mock_global_link
        end
        it 'should save the glu' do
          ContextLink::NegativeContextLink.stub(:new).and_return @mock_cl
          @mock_cl.should_receive(:save)
          xhr :post, :create, @params
        end
        it 'increment the caches' do
          Link::GlobalLink::NegativeGlobalLink.where(:node_from_id => @params["global_link"]["global_node_from_id"], :node_to_id => @params["global_link"]["global_node_to_id"]).first.should be_nil
          xhr :post, :create, @params
          global_link = Link::GlobalLink::NegativeGlobalLink.where(:node_from_id => @params["global_link"]["global_node_from_id"], :node_to_id => @params["global_link"]["global_node_to_id"]).first
          global_link.users_count.should == 1
        end
        it 'should render the link partial for the newly associated link (not tested)' do
          @mock_cl.stub(:save).and_return true
          ContextLink::NegativeContextLink.stub(:new).and_return(@mock_cl)
          xhr :post, :create, @params
          response.should render_template(:partial => "_a_link")
        end
        it 'should assign the correct link' do
          post :create, @params
          new_link = ContextLink.where(@params["global_link"].merge(:user_id => @user.id, :question_id => @question.id)).first
          assigns(:context_link).should == new_link
        end
        it 'initialise a new link with the correct parameters' do
          ContextLink::NegativeContextLink.should_receive(:new).with(@params["global_link"].merge("question" => @question, "user" => @user)).and_return @mock_cl
          xhr :post, :create, @params
        end
      end
      context 'when save returns false for glu' do
        before do
          @params = {"type" => "Negative", "global_link"=>{"global_node_from_id"=>@node_one.id.to_s, "global_node_to_id"=>@node_two.id.to_s}}
          @mock_cl = mock('context_link')
          @mock_global_link = mock('global_link')
          @mock_cl.stub(:save).and_return false
          @mock_cl.stub(:link).and_return @mock_global_link
        end
        it 'initialise a new link with the correct parameters' do
          ContextLink::NegativeContextLink.should_receive(:new).and_return @mock_cl
          Link::GlobalLink.should_receive(:new).and_return @mock_global_link
          xhr :post, :create, @params
        end
        it 'should render the link template' do
          ContextLink::NegativeContextLink.stub(:new).and_return @mock_cl
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
      @node_one = @cn1.global_node
      @cn2 = ContextNode.create(:user=>@user, :title=>'test', :question=>@question)
      @node_two = @cn2.global_node
      @params_one = {"type" => "Positive", "global_link"=>{"global_node_from_id"=>@node_one.id.to_s, "global_node_to_id"=>@node_two.id.to_s}}
      @context_link = ContextLink::PositiveContextLink.create(@params_one["global_link"].merge(:question => @question, :user => @user))
      @user_two = FactoryGirl.create(:user, :email => "user2@test.com")
      @context_linkuser2 = ContextLink::PositiveContextLink.create!(@params_one["global_link"].merge(:question => @question, :user => @user_two))
      @params_one = {"type" => "Positive", "global_link"=>{"global_node_from_id"=>@node_one.id.to_s, "global_node_to_id"=>@node_two.id.to_s}, :id => @context_link.global_link.id, :view_configuration => {:links_from_question => @question.id}}
      @context_link.global_link.should == @context_linkuser2.global_link
    end
    #update will destroy and then create as too much logic for an after save if we check if we need to to destroy question links etc.
    context 'when ajax request' do
      context 'with valid params' do
        before do
          @mock_cl = mock('context_link')
          @mock_cl_2 = mock('context_link')
          @mock_global_link = mock('global_link')
          @mock_cl_2.stub(:save).and_return true
          @mock_cl_2.stub(:link).and_return @mock_global_link
          @mock_cl.stub(:destroy).and_return true
          @mock_relation = mock('relation')
        end
        it 'should save the glu' do
          @mock_relation.stub(:where).and_return [@mock_cl]
          ContextLink.stub(:with_all_associations).and_return @mock_relation
          @mock_cl.should_receive(:destroy)
          xhr :put, :destroy, @params_one
        end
        it 'decrement the caches' do
          global_link = Link::GlobalLink.where(@params_one["link"]).first
          global_link.should_not be_nil
          global_link.reload.users_count.should == 2
          global_link.users_count.should == 2 
          xhr :post, :destroy, @params_one
          global_link = Link::GlobalLink.where(@params_one["link"]).first
          global_link.users_count.should == 1
          global_link.users_count.should == 1
        end
        it 'should render the link partial for the newly associated link (not tested)' do
          xhr :put, :destroy, @params_one
          response.should render_template(:partial => "_a_link")
        end
        it 'should assign the correct link' do
          @new_link_params = {"global_link"=>{"global_node_from_id"=>@node_one.id.to_s, "global_node_to_id"=>@node_two.id.to_s}}
          new_link = ContextLink::PositiveContextLink.new(@new_link_params["global_link"])
          Link::GlobalLink.should_receive(:new).with(:node_from_id => @new_link_params["global_link"]["global_node_from_id"], :node_to_id => @new_link_params["global_link"]["global_node_to_id"]).and_return new_link
          xhr :put, :destroy, @params_one
        end
      end
      context 'when destroy or save returns false for glu' do
        before do
          @context_link.stub(:destroy).and_return false
          ContextLink::PositiveContextLink.stub(:find).and_return @context_link
        end
        it 'should render the link template' do
          xhr :put, :destroy, @params_one
          response.should render_template(:partial => "_a_link")
        end
      end
    end
  end
end
