require 'spec_helper'
require 'controllers/application_controller_spec_helper'

describe ApplicationController do

  describe 'update_view_configuration' do
    controller do
      def index 
        render :nothing => true
      end
    end
    before do
      @user = FactoryGirl.create(:user)
      @question = FactoryGirl.create(:question)
      @node = mock('node')
      @node.stub(:id).and_return 1
    end
    context 'when there is no existing configuration' do
      before do
        @view_configuration = {
                                :current_node => @node.id,
                                :nodes_question => @question.id,
                                :nodes_user => @user.id,
                                :nodes_query => "A node",
                                :argument_user => @question.id,
                                :argument_question => @user.id,
                                :links_to_question => @question.id,
                                :links_to_user => @user.id,
                                :links_to_query => "A node",
                                :links_from_question => @question.id,
                                :links_from_user => @user.id,
                                :links_from_query => "A node"
                              }
        @params = {:view_configuration => @view_configuration}
      end
      it 'should set the correct view configuration' do
        get :index, @params
        @view_configuration.each do |key, value|
          session[key].should == value.to_s
        end
      end
      it 'should set the correct defaults when nothing is set' do
        pending
      end
    end
    context 'when there is an existing configuration' do
      context 'and some configuration settings are overridden' do
        before do
          @user_two = FactoryGirl.create(:user, :email => "new@test.com")
          @existing_view_configuration = 
                               {
                                  :current_node => @node.id,
                                  :nodes_question => @question.id,
                                  :nodes_user => @user.id,
                                  :links_to_question => @question.id,
                                  :links_to_user => @user.id
                                }
          @new_view_configuration = 
                               {
                                  :nodes_query => "A node",
                                  :argument_user => @user_two.id,
                                  :links_to_user => @user_two.id
                                }
          @unchanged_view_configuration = 
                               {
                                  :current_node => @node.id,
                                  :nodes_question => @question.id.to_s,
                                  :nodes_user => @user.id.to_s,
                                  :argument_question => nil,
                                  :links_to_question => @question.id.to_s,
                                  :links_to_query => nil,
                                  :links_from_question => nil,
                                  :links_from_user => nil,
                                  :links_from_query => nil
                                }
          @params = {:view_configuration => @new_view_configuration}
          @existing_view_configuration.each do |key, value|
            session[key] = value.to_s
          end
        end
        it 'should override the existing configuration if overridden' do
          get :index, @params
          @new_view_configuration.each do |key, value|
            session[key].should == value.to_s
          end
        end
        it 'should maintain the existing configuration if not overridden' do
          #unset are nil but set as nil is ""
          get :index, @params
          @unchanged_view_configuration.each do |key, value|
            session[key].should == value
          end
        end
        it 'should set the correct defaults when nothing is set' do
          pending
        end
      end
      context 'and all settings are overridden' do
        before do
          @user_two = FactoryGirl.create(:user, :email => "new@test.com")
          @question_two = FactoryGirl.create(:question, :name => "new name")
          @existing_view_configuration = 
                               {
                                :current_node => @node.id,
                                :nodes_question => @question.id,
                                :nodes_user => @user.id,
                                :nodes_query => "A node",
                                :argument_user => @question.id,
                                :argument_question => @user.id,
                                :links_to_question => @question.id,
                                :links_to_user => @user.id,
                                :links_to_query => "A node",
                                :links_from_question => @question.id,
                                :links_from_user => @user.id,
                                :links_from_query => "A node"
                               }
          @new_view_configuration = 
                               {
                                :current_node => @node.id,
                                :nodes_question => @question_two.id,
                                :nodes_user => @user_two.id,
                                :nodes_query => "Another node",
                                :argument_user => @question_two.id,
                                :argument_question => @user_two.id,
                                :links_to_question => @question_two.id,
                                :links_to_user => @user_two.id,
                                :links_to_query => "Another node",
                                :links_from_question => @question_two.id,
                                :links_from_user => @user_two.id,
                                :links_from_query => "Another node"
                               }
          @params = {:view_configuration => @new_view_configuration}
          @existing_view_configuration.each do |key, value|
            session[key] = value.to_s
          end
        end
        it 'should override the existing configuration if overridden' do
          get :index, @params
          @new_view_configuration.each do |key, value|
            session[key].should == value.to_s
          end
        end
        it 'should set the correct defaults when nothing is set' do
          pending
        end
      end
    end
    
    it 'it should set the correct expiry' do
      #auto set to browser close apparently
      pending
    end
    it 'should be as secure as all the when stuff' do
      pending
    end
    it 'should behave correctly when both a question and user set (if not allowed)' do
      pending
    end
    it 'should decode the hashed params' do
      pending
    end
  end
  
  describe 'setting view resources' do
    before do
      @user = FactoryGirl.create(:user)
      @question = FactoryGirl.create(:question)
      @query = "Part of a node title"
    end
    describe 'set_nodes' do
      controller do
        before_filter :set_nodes
        def index 
          render :nothing => true
        end
      end
      it_should_behave_like 'a controller setting nodes for the view', "node", nil
      it_should_behave_like 'a controller setting nodes for the view', "node", "3"
    end
    describe 'setting links' do
      before do
        @current_node = mock('node')
        @current_node.stub(:find_view_links_from_by_context)
        @current_node.stub(:find_view_links_to_by_context)
        Node::GlobalNode.stub(:find).and_return @current_node
      end
      describe 'set_links_to' do
        controller do
          before_filter :set_node
          before_filter :set_links_to
          def index 
            render :nothing => true
          end
        end
        it_should_behave_like 'a controller setting links for the view', "to", "link", nil
        it_should_behave_like 'a controller setting links for the view', "to", "link", "3"
      end
      describe 'set_links_from' do
        controller do
          before_filter :set_node
          before_filter :set_links_from
          def index 
            render :nothing => true
          end
        end
        it_should_behave_like 'a controller setting links for the view', "from", "link", nil
        it_should_behave_like 'a controller setting links for the view', "from", "link", "3"
      end
    end
    describe 'set_argument' do
      it 'should call set argument with the correct params' do
        pending
      end
    end
  end
###These three may want to go to sub controllers, merge with show in arg case? do this so don't do all setting through callbacks for these actions
  describe 'reload nodes section' do
    it 'should call set nodes only and render the correct response' do
      pending
    end
  end

  describe 'reload links section' do
    it 'should call set links only and render the correct response' do
      pending
    end
  end

  describe 'reload argument section' do
    it 'should call set argument only and render the correct response' do
      pending
    end
  end
###
end
