
require 'spec_helper'

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
    end
    context 'when there is no existing configuration' do
      before do
        @view_configuration = {
                                :nodes_question => @question.id,
                                :nodes_user => @user.id,
                                :nodes_query => "A node",
                                :argument_user => @question.id,
                                :argument_question => @user.id,
                                :links_question => @question.id,
                                :links_user => @user.id,
                                :links_query => "A node"
                              }
        @params = {:view_configuration => @view_configuration}
      end
      it 'should set the correct view configuration' do
        get :index, @params
        @view_configuration.each do |key, value|
          response.cookies[key.to_s].should == value.to_s
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
                                  :nodes_question => @question.id,
                                  :nodes_user => @user.id,
                                  :links_question => @question.id,
                                  :links_user => @user.id
                                }
          @new_view_configuration = 
                               {
                                  :nodes_query => "A node",
                                  :argument_user => @user_two.id,
                                  :links_user => @user_two.id
                                }
          @unchanged_view_configuration = 
                               {
                                  :nodes_question => @question.id.to_s,
                                  :nodes_user => @user.id.to_s,
                                  :argument_question => nil,
                                  :links_question => @question.id.to_s,
                                  :links_query => nil
                                }
          @params = {:view_configuration => @new_view_configuration}
          @existing_view_configuration.each do |key, value|
            request.cookies[key] = value.to_s
          end
        end
        it 'should override the existing configuration if overridden' do
          get :index, @params
          @new_view_configuration.each do |key, value|
            request.cookie_jar[key.to_s].should == value.to_s
          end
        end
        it 'should maintain the existing configuration if not overridden' do
          get :index, @params
          @unchanged_view_configuration.each do |key, value|
            request.cookie_jar[key.to_s].should == value
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
                                :nodes_question => @question.id,
                                :nodes_user => @user.id,
                                :nodes_query => "A node",
                                :argument_user => @question.id,
                                :argument_question => @user.id,
                                :links_question => @question.id,
                                :links_user => @user.id,
                                :links_query => "A node"
                               }
          @new_view_configuration = 
                               {
                                :nodes_question => @question_two.id,
                                :nodes_user => @user_two.id,
                                :nodes_query => "Another node",
                                :argument_user => @question_two.id,
                                :argument_question => @user_two.id,
                                :links_question => @question_two.id,
                                :links_user => @user_two.id,
                                :links_query => "Another node"
                               }
          @params = {:view_configuration => @new_view_configuration}
          @existing_view_configuration.each do |key, value|
            request.cookies[key] = value.to_s
          end
        end
        it 'should override the existing configuration if overridden' do
          get :index, @params
          @new_view_configuration.each do |key, value|
            request.cookie_jar[key.to_s].should == value.to_s
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
  
  describe 'set_nodes' do
    context 'when the question is set' do

    end
  end

  describe 'set_links' do

  end

  describe 'set_argument' do

  end

end
