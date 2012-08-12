require 'spec_helper'

describe Node do
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
                                         :nodes_question => @question.id,
                                         :nodes_user => nil,
                                         :nodes_query => nil 
                                       }
      end
      it 'should return the correct question nodes' do
        Node.find_by_context(@existing_view_configuration).should == [@context_node1.question_node, @context_node3.question_node]
      end
      context 'when the user is set' do
        before do
          @existing_view_configuration.merge!(:nodes_user => @user.id)
        end
        it 'should return the correct context nodes' do
          Node.find_by_context(@existing_view_configuration).should == [@context_node1]
        end
        context 'when the query is set' do
          before do
            @existing_view_configuration.merge!(:nodes_query => @query)
          end
          it 'should return the correct context nodes' do
            Node.find_by_context(@existing_view_configuration).should == [@context_node1]
          end
        end
      end
      context 'when the query is set' do
        before do
          @existing_view_configuration.merge!(:nodes_query => @query)
        end
        it 'should return the correct question nodes' do
          Node.find_by_context(@existing_view_configuration).should == [@context_node1.question_node, @context_node3.question_node]
        end
      end
    end
    context 'when the user is set' do
      before do
        @existing_view_configuration = {
                                         :nodes_user => @user.id,
                                         :nodes_question => nil,
                                         :nodes_query => nil
                                       }
      end
      it 'should return the correct user nodes' do
        Node.find_by_context(@existing_view_configuration).should == [@context_node1.user_node, @context_node4.user_node]
      end
      context 'when the query is set' do
        before do
          @existing_view_configuration.merge!(:nodes_query => @query)
        end
        it 'should return the correct user nodes' do
          Node.find_by_context(@existing_view_configuration).should == [@context_node1.user_node]
        end
      end
    end
    context 'when the query is set' do
      before do
        @existing_view_configuration = {
					 :nodes_query => @query,
                                         :nodes_question => nil,
                                         :nodes_user => nil
                                       }
      end
      it 'should return the correct global nodes' do
        Node.find_by_context(@existing_view_configuration).should == [@context_node1.global_node, @context_node3.global_node]
      end
    end
  end
end
