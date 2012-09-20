require 'spec_helper'
require 'models/node_spec_helper.rb'

describe Node do
  describe 'finding links' do
    before do
      context_node = ContextNode.create(:user=>@user, :question=>@question, :title => "Part of a node title, here it is!")
      @node = context_node.global_node
      @params = {}
    end
    describe 'find_view_links_from_by_context' do
      it 'should call find_view_links_by_context' do
        @node.should_receive(:find_view_links_by_context).with(:from, @params)
        @node.find_view_links_from_by_context @params
      end
    end
    describe 'find_view_links_from_by_context' do
      it 'should call find_view_links_by_context' do
        @node.should_receive(:find_view_links_by_context).with(:to, @params)
        @node.find_view_links_to_by_context @params
      end
    end
    describe 'find_view_links_by_context' do
      before do
        @user = FactoryGirl.create(:user)
        @user2 = FactoryGirl.create(:user, :email=>"another@test.com")
        @question = FactoryGirl.create(:question)
        @question2 = FactoryGirl.create(:question, :name => 'Aaa')
        @query = "Part of a node title"
        @context_node1 = ContextNode.create(:user=>@user, :question=>@question, :title => "Part of a node title, here it is!")
        @context_node2 = ContextNode.create(:user=>@user2, :question=>@question2, :title => 'Title')
        @context_node3 = ContextNode.create(:user=>@user2, :question=>@question, :title => "And another! Part of a node title")
        @context_node4 = ContextNode.create(:user=>@user, :question=>@question2, :title => 'Title')
        Node::GlobalNode.reindex
        Node::QuestionNode.reindex
        Node::UserNode.reindex
        ContextNode.reindex
      end
      context 'when the direction is to' do

      end
      context 'when the direction is from' do

      end
    end
  end
  describe 'search' do
    before do
      @user = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user, :email=>"another@test.com")
      @question = FactoryGirl.create(:question)
      @question2 = FactoryGirl.create(:question, :name => 'Aaa')
      @query = "Part of a node title"
      @context_node1 = ContextNode.create(:user=>@user, :question=>@question, :title => "Part of a node title, here it is!")
      @context_node2 = ContextNode.create(:user=>@user2, :question=>@question2, :title => 'Title')
      @context_node3 = ContextNode.create(:user=>@user2, :question=>@question, :title => "And another! Part of a node title")
      @context_node4 = ContextNode.create(:user=>@user, :question=>@question2, :title => 'Title')
      Node::GlobalNode.reindex
      Node::QuestionNode.reindex
      Node::UserNode.reindex
      ContextNode.reindex
    end
    context 'when the question is set' do
      before do
        @existing_view_configuration = {
                                         :question => @question.id,
                                         :user => nil,
                                         :query => nil 
                                       }
      end
      it 'should return the correct question nodes' do
        Node.find_by_context(@existing_view_configuration).should == [@context_node1.global_node, @context_node3.global_node]
      end
      context 'when the user is set' do
        before do
          @existing_view_configuration.merge!(:user => @user.id)
        end
        it 'should return the correct context nodes' do
          Node.find_by_context(@existing_view_configuration).should == [@context_node1.global_node]
        end
        context 'when the query is set' do
          before do
            @existing_view_configuration.merge!(:query => @query)
          end
          it 'should return the correct context nodes' do
            Node.find_by_context(@existing_view_configuration).should == [@context_node1.global_node]
          end
        end
      end
      context 'when the query is set' do
        before do
          @existing_view_configuration.merge!(:query => @query)
        end
        it 'should return the correct question nodes' do
          Node.find_by_context(@existing_view_configuration).should == [@context_node1.global_node, @context_node3.global_node]
        end
      end
    end
    context 'when the user is set' do
      before do
        @existing_view_configuration = {
                                         :user => @user.id,
                                         :question => nil,
                                         :query => nil
                                       }
      end
      it 'should return the correct user nodes' do
        Node.find_by_context(@existing_view_configuration).should == [@context_node1.global_node, @context_node4.global_node]
      end
      context 'when the query is set' do
        before do
          @existing_view_configuration.merge!(:query => @query)
        end
        it 'should return the correct user nodes' do
          Node.find_by_context(@existing_view_configuration).should == [@context_node1.global_node]
        end
      end
    end
    context 'when the query is set' do
      before do
        @existing_view_configuration = {
					 :query => @query,
                                         :question => nil,
                                         :user => nil
                                       }
      end
      it 'should return the correct global nodes' do
        Node.find_by_context(@existing_view_configuration).should == [@context_node1.global_node, @context_node3.global_node]
      end
    end
  end
end
