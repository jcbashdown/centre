require 'spec_helper'

describe ContextNode do
  before do
    @user = FactoryGirl.create(:user)
    @user_two = FactoryGirl.create(:user, :email => "test@email.com")
    @question = FactoryGirl.create(:question)
    @question2 = FactoryGirl.create(:question, :name => 'Aaa')
  end

  describe 'creation' do
    describe 'creation with no existing inclusion in qns context_nodes' do
      it 'should create 2 questions_nodes' do
        expect {
          ContextNode.create(:user=>@user, :question=>@question, :title => 'Title')
        }.to change(Node::QuestionNode, :count).by(1)
      end
      it 'should create 2 questions_nodes' do
        expect {
          ContextNode.create(:user=>@user, :question=>@question, :title => 'Title')
        }.to change(Node::GlobalNode, :count).by(1)
      end
      it 'should create 2 context_nodes' do
        expect {
          ContextNode.create(:user=>@user, :question=>@question, :title => 'Title')
        }.to change(ContextNode, :count).by(1)
      end
      it 'should create 2 context_nodes' do
        expect {
          ContextNode.create(:user=>@user, :question=>@question, :title => 'Title')
        }.to change(Node::UserNode, :count).by(1)
      end
      it 'should create a questions_node for the question and node and all and node' do
        context_node = ContextNode.create(:user=>@user, :question=>@question, :title => 'Title')
        context_node2 = ContextNode.create(:user=>@user, :question=>@question2, :title => 'Title')
        nu = context_node.user_node
        nu2 = context_node2.user_node
        nu.should_not be_nil
        nu2.should_not be_nil
        nu.should == nu2
        nu.reload.users_count.should == 2 
      end
      it 'should create a questions_node for the question and node and all and node' do
        context_node = ContextNode.create(:user=>@user, :question=>@question, :title => 'Title')
        context_node2 = ContextNode.create(:user=>@user, :question=>@question2, :title => 'Title')
        qn = context_node.question_node
        qn2 = context_node2.question_node
        qn.should_not be_nil
        qn2.should_not be_nil
        qn.should_not == qn2
        qn.reload.users_count.should == 1 
        qn2.reload.users_count.should == 1 
      end
      it 'should create a questions_user_node for the question and node and all and node' do
        context_node = ContextNode.create(:user=>@user, :question=>@question, :title => 'Title')
        context_node.should be_persisted
        context_node.should be_a(ContextNode)
      end
    end
    describe 'creation with existing nu' do
      before do
        @context_node = ContextNode.create(:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => false)
        @context_node.user_node.should_not be_nil
      end
      context 'when in the question' do
        it 'should create 0 questions_nodes' do
          expect {
            ContextNode.create(:user=>@user, :question=>@question, :title => 'Title')
          }.to change(Node::QuestionNode, :count).by(0)
        end
        it 'should create 0 context_nodes' do
          expect {
            ContextNode.create(:user=>@user, :question=>@question, :title => 'Title')
          }.to change(ContextNode, :count).by(0)
        end
        it 'should create 0 user_nodes' do
          expect {
            ContextNode.create(:user=>@user, :question=>@question, :title => 'Title')
          }.to change(Node::UserNode, :count).by(0)
        end
        it 'there should be only one context_node etc for this description' do
          ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id, :is_conclusion => false).count.should == 1
          Node::UserNode.where(:user_id=>@user.id, :title=>'Title', :is_conclusion => false).count.should == 1
          Node::QuestionNode.where(:title=>'Title', :question_id=>@question.id, :is_conclusion => false).count.should == 1
          context_node = ContextNode.create(:user=>@user, :question=>@question, :title => 'Title')
          ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id, :is_conclusion => false).count.should == 1
          Node::UserNode.where(:user_id=>@user.id, :title=>'Title', :is_conclusion => false).count.should == 1
          Node::QuestionNode.where(:title=>'Title', :question_id=>@question.id, :is_conclusion => false).count.should == 1
        end
        context 'when new user' do
          before do
            @user = FactoryGirl.create(:user, :email=>"another@test.com")
          end
          it 'should create 0 questions_nodes' do
            expect {
              ContextNode.create(:user=>@user, :question=>@question, :title => 'Title')
            }.to change(Node::QuestionNode, :count).by(0)
          end
          it 'should create 1 context_nodes' do
            expect {
              ContextNode.create(:user=>@user, :question=>@question, :title => 'Title')
            }.to change(ContextNode, :count).by(1)
          end
          it 'should create 1 user_nodes' do
            expect {
              ContextNode.create(:user=>@user, :question=>@question, :title => 'Title')
            }.to change(Node::UserNode, :count).by(1)
          end
          it 'should create a questions_user_node etc' do
            context_node = ContextNode.create(:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => true)
            ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id, :is_conclusion => true).count.should == 1
            Node::UserNode.where(:user_id=>@user.id, :title=>'Title', :is_conclusion => true).count.should == 1
            Node::QuestionNode.where(:title=>'Title', :question_id=>@question.id, :is_conclusion => true).count.should == 0
            @user = FactoryGirl.create(:user, :email=>"another@test2.com")
            context_node = ContextNode.create(:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => true)
            ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id, :is_conclusion => true).count.should == 1
            Node::UserNode.where(:user_id=>@user.id, :title=>'Title', :is_conclusion => true).count.should == 1
            #fix is conclusion, this is fine but write and test
            Node::QuestionNode.where(:title=>'Title', :question_id=>@question.id, :is_conclusion => true).count.should == 1
          end
        end
      end
      context 'when outside of the question' do
        context 'when existing nu' do
          before do
            Node::UserNode.where(:user_id=>@user.id, :title => 'Title').count.should == 1
          end
          it 'should create 1 questions_nodes' do
            expect {
              ContextNode.create(:user=>@user, :question=>@question2, :title => 'Title')
            }.to change(Node::QuestionNode, :count).by(1)
          end
          it 'should create 1 context_nodes' do
            expect {
              ContextNode.create(:user=>@user, :question=>@question2, :title => 'Title')
            }.to change(ContextNode, :count).by(1)
          end
          it 'should create 1 user_nodes' do
            expect {
              ContextNode.create(:user=>@user, :question=>@question2, :title => 'Title')
            }.to change(Node::UserNode, :count).by(0)
          end
          it 'should create a questions_user_node etc for the question and node' do
            context_node = ContextNode.create(:user=>@user, :question=>@question2, :title => 'Title')
            ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question2.id).count.should == 1
            Node::UserNode.where(:user_id=>@user.id, :title=>'Title').count.should == 1
            Node::QuestionNode.where(:title=>'Title', :question_id=>@question2.id).count.should == 1
          end
        end
        context 'when no existing nu' do
          before do
            @user = FactoryGirl.create(:user, :email=>"another@test.com")
          end
          it 'should create 0 questions_nodes' do
            expect {
              ContextNode.create(:user=>@user, :title=>'Title', :question=>@question2)
            }.to change(Node::QuestionNode, :count).by(1)
          end
          it 'should create 1 context_nodes' do
            expect {
              ContextNode.create(:user=>@user, :title=>'Title', :question=>@question2)
            }.to change(ContextNode, :count).by(1)
          end
          it 'should create 1 user_nodes' do
            expect {
              ContextNode.create(:user=>@user, :title=>'Title', :question=>@question2)
            }.to change(Node::UserNode, :count).by(1)
          end
          it 'should create a questions_user_node etc for the question and node' do
            context_node = ContextNode.create(:user=>@user, :question=>@question2, :title => 'Title')
            ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question2.id).count.should == 1
            Node::UserNode.where(:user_id=>@user.id, :title=>'Title').count.should == 1
            Node::QuestionNode.where(:title=>'Title', :question_id=>@question2.id).count.should == 1
          end
        end
      end
    end
  end
  describe 'deletion' do
    context 'when there are no associated links' do
      describe 'when the question nodes question node user count is less than two (when there is only this user)' do
        before do
          context_node = ContextNode.create(:user=>@user, :title=>'Title', :question=>@question, :is_conclusion => false)
          context_node.question_node.reload.users_count.should == 1
        end
        it 'should destroy 1 node' do
          expect {
            ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
          }.to change(Node::GlobalNode, :count).by(-1)
        end
        it 'should destroy 1 questions_nodes' do
          expect {
            ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
          }.to change(Node::QuestionNode, :count).by(-1)
        end
        it 'should destroy 1 questions_nodes_users' do
          expect {
            ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
          }.to change(ContextNode, :count).by(-1)
        end
        it 'should destroy 1 questions_nodes_users' do
          expect {
            ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
          }.to change(Node::UserNode, :count).by(-1)
        end
        it 'should destroy the question node' do
          qn = Node::QuestionNode.where(:title=>'Title', :question_id=>@question.id)[0]
          qn.should_not be_nil
          ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
          qn = Node::QuestionNode.where(:title=>'Title', :question_id=>@question.id)[0]
          qn.should be_nil
        end
        it 'should destroy the node user' do
          ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
          nu = Node::UserNode.where(:title=>'Title', :user_id=>@user.id)[0]
          nu.should be_nil
        end
        it 'should destroy the node' do
          ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
          Node.where(:title=>'Title')[0].should be_nil
        end
        it 'should destroy the question node user' do
          ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
          ContextNode.where(:title=>'Title', :question_id=>@question.id)[0].should be_nil
        end
        context 'with another user for the question node' do
          before do
            @user = FactoryGirl.create(:user, :email => "a@test.com")
            context_node = ContextNode.create(:user=>@user, :title=>'Title', :question=>@question, :is_conclusion => false)
            context_node.question_node.reload.users_count.should == 2
          end
          it 'should destroy 0 questions_nodes' do
            expect {
              ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
            }.to change(Node::GlobalNode, :count).by(0)
          end
          it 'should destroy 0 questions_nodes' do
            expect {
              ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
            }.to change(Node::QuestionNode, :count).by(0)
          end
          it 'should destroy 1 questions_nodes_users' do
            expect {
              ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
            }.to change(ContextNode, :count).by(-1)
          end
          it 'should destroy 1 nodes_users' do
            expect {
              ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
            }.to change(Node::UserNode, :count).by(-1)
          end
          it 'should update the caches' do
            qn = Node::QuestionNode.where(:title=>'Title', :question_id=>@question.id)[0]
            qn.should_not be_nil
            ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
            qn = Node::QuestionNode.where(:title=>'Title', :question_id=>@question.id)[0]
            qn.should_not be_nil
            qn.users_count.should == 1
            gn = Node::GlobalNode.where(:title=>'Title')[0]
            gn.should_not be_nil
            gn.users_count.should == 1
          end
          it 'should destroy the node user' do
            ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
            nu = Node::UserNode.where(:title=>'Title', :user_id=>@user.id)[0]
            nu.should be_nil
          end
          it 'should not destroy the node and question node and should destroy the context_node' do
            @user_two = FactoryGirl.create(:user, :email=>"another@test.com")
            context_node = ContextNode.create(:user=>@user_two, :question=>@question, :title => 'Title', :is_conclusion => true)
            ContextNode.where(:user_id=>@user_two.id, :title=>'Title', :question_id=>@question.id, :is_conclusion => true).count.should == 1
            Node::UserNode.where(:user_id=>@user_two.id, :title=>'Title', :is_conclusion => true).count.should == 1
            Node::QuestionNode.where(:title=>'Title', :question_id=>@question.id, :is_conclusion => true).count.should == 0
            @user_three = FactoryGirl.create(:user, :email=>"another@test2.com")
            context_node = ContextNode.create(:user=>@user_three, :question=>@question, :title => 'Title', :is_conclusion => true)
            ContextNode.where(:user_id=>@user_three.id, :title=>'Title', :question_id=>@question.id, :is_conclusion => true).count.should == 1
            Node::UserNode.where(:user_id=>@user_three.id, :title=>'Title', :is_conclusion => true).count.should == 1
            Node::QuestionNode.where(:title=>'Title', :question_id=>@question.id, :is_conclusion => true).count.should == 0
            ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
            Node::QuestionNode.where(:title=>'Title', :question_id=>@question.id, :is_conclusion => true)[0].should_not be_nil
            Node::GlobalNode.where(:title=>'Title')[0].should_not be_nil
            ContextNode.where(:title=>'Title', :user_id => @user.id, :question_id=>@question.id)[0].should be_nil
          end
        end
      end
    end
    describe 'with existing links' do
      before do
        @context_node1 = ContextNode.create(:title => 'title', :question => @question, :user => @user)
        @context_node2 = ContextNode.create(:title => 'test', :question => @question, :user => @user)
        @context_node3 = ContextNode.create(:title => 'another', :question => @question, :user => @user)
        @context_link = ContextLink.create(:user=>@user, :question => @question, :node_from_id => @context_node1.node.id, :node_to_id => @context_node2.node.id, :value => 1)
      end
      it 'should destroy 1 node' do
        expect {
          @context_node1.destroy
        }.to change(Node::GlobalNode, :count).by(-1)
      end
      it 'should destroy 1 questions_nodes' do
        expect {
          @context_node1.destroy
        }.to change(Node::QuestionNode, :count).by(-1)
      end
      it 'should destroy 1 questions_nodes_users' do
        expect {
          @context_node1.destroy
        }.to change(ContextNode, :count).by(-1)
      end
      it 'should destroy 1 nodes_users' do
        expect {
          @context_node1.destroy
        }.to change(Node::UserNode, :count).by(-1)
      end

      it 'should destroy 1 link' do
        expect {
          @context_node1.destroy
        }.to change(Link::GlobalLink, :count).by(-1)
      end

      it 'should destroy 1 context_link' do
        expect {
          @context_node1.destroy
        }.to change(ContextLink, :count).by(-1)
      end

      it 'should destroy 1 context_link' do
        expect {
          @context_node1.destroy
        }.to change(Link::QuestionLink, :count).by(-1)
      end

      it 'should destroy 1 context_link' do
        expect {
          @context_node1.destroy
        }.to change(Link::UserLink, :count).by(-1)
      end

      it 'update the caches' do
        @context_node2.reload.upvotes_count.should == 1
        @context_node2.user_node.reload.upvotes_count.should == 1
        @context_node2.question_node.reload.upvotes_count.should == 1
        @context_node2.node.reload.upvotes_count.should == 1
        @context_node1.destroy
        @context_node2.reload.upvotes_count.should == 0 
        @context_node2.user_node.reload.upvotes_count.should == 0
        @context_node2.question_node.reload.upvotes_count.should == 0
        @context_node2.node.reload.upvotes_count.should == 0
      end
      
      context 'when another user has the link in this question' do
        before do
          @context_link2 = ContextLink.create(:user=>@user_two, :question => @question, :node_from_id => @context_node1.node.id, :node_to_id => @context_node2.node.id, :value => 1)
        end
        it 'should destroy 0 node' do
          expect {
            @context_node1.destroy
          }.to change(Node::GlobalNode, :count).by(0)
        end
        it 'should destroy 0 questions_nodes' do
          expect {
            @context_node1.destroy
          }.to change(Node::QuestionNode, :count).by(0)
        end
        it 'should destroy 1 questions_nodes_users' do
          expect {
            @context_node1.destroy
          }.to change(ContextNode, :count).by(-1)
        end
        it 'should destroy 1 nodes_users' do
          expect {
            @context_node1.destroy
          }.to change(Node::UserNode, :count).by(-1)
        end
  
        it 'should destroy 0 link' do
          expect {
            @context_node1.destroy
          }.to change(Link::GlobalLink, :count).by(0)
        end
  
        it 'should destroy 1 context_link' do
          expect {
            @context_node1.destroy
          }.to change(ContextLink, :count).by(-1)
        end
  
        it 'should destroy 0 gl' do
          expect {
            @context_node1.destroy
          }.to change(Link::QuestionLink, :count).by(0)
        end
  
        it 'should destroy 1 lu' do
          expect {
            @context_node1.destroy
          }.to change(Link::UserLink, :count).by(-1)
        end
  
        it 'update the caches' do
          @context_node2.reload.upvotes_count.should == 1
          @context_node2.user_node.reload.upvotes_count.should == 1
          @context_node2.question_node.reload.upvotes_count.should == 2
          @context_node2.node.reload.upvotes_count.should == 2
          @context_node1.destroy
          @context_node2.reload.upvotes_count.should == 0 
          @context_node2.user_node.reload.upvotes_count.should == 0
          @context_node2.question_node.reload.upvotes_count.should == 1
          @context_node2.node.reload.upvotes_count.should == 1
        end
      end
  
      context 'when another user has another link in this question which uses the same node from' do
        before do
          @context_link2 = ContextLink.create(:user=>@user_two, :question => @question, :node_from_id => @context_node1.node.id, :node_to_id => @context_node3.node.id, :value => 1)
        end
        it 'should destroy 0 node (due to shared node from and diff users)' do
          expect {
            @context_node1.destroy
          }.to change(Node::GlobalNode, :count).by(0)
        end
        it 'should destroy 0 questions_nodes' do
          expect {
            @context_node1.destroy
          }.to change(Node::QuestionNode, :count).by(0)
        end
        it 'should destroy 1 questions_nodes_users' do
          expect {
            @context_node1.destroy
          }.to change(ContextNode, :count).by(-1)
        end
        it 'should destroy 1 nodes_users' do
          expect {
            @context_node1.destroy
          }.to change(Node::UserNode, :count).by(-1)
        end
  
        it 'should destroy 1 link' do
          expect {
            @context_node1.destroy
          }.to change(Link::GlobalLink, :count).by(-1)
        end
  
        it 'should destroy 1 context_link' do
          expect {
            @context_node1.destroy
          }.to change(ContextLink, :count).by(-1)
        end
  
        it 'should destroy 1 gl' do
          expect {
            @context_node1.destroy
          }.to change(Link::QuestionLink, :count).by(-1)
        end
  
        it 'should destroy 1 lu' do
          expect {
            @context_node1.destroy
          }.to change(Link::UserLink, :count).by(-1)
        end
  
        it 'update the caches' do
          @context_node2.reload.upvotes_count.should == 1
          @context_node2.user_node.reload.upvotes_count.should == 1
          @context_node2.question_node.reload.upvotes_count.should == 1
          @context_node2.node.reload.upvotes_count.should == 1
          @context_node1.destroy
          @context_node2.reload.upvotes_count.should == 0 
          @context_node2.user_node.reload.upvotes_count.should == 0
          @context_node2.question_node.reload.upvotes_count.should == 0
          @context_node2.node.reload.upvotes_count.should == 0
        end
      end
  
      context 'when another user has the link in another question' do
        before do
          @context_link2 = ContextLink.create(:user=>@user_two, :question => @question2, :node_from_id => @context_node1.node.id, :node_to_id => @context_node2.node.id, :value => 1)
        end
        it 'should destroy 0 node' do
          expect {
            @context_node1.destroy
          }.to change(Node::GlobalNode, :count).by(0)
        end
        it 'should destroy 1 questions_nodes' do
          expect {
            @context_node1.destroy
          }.to change(Node::QuestionNode, :count).by(-1)
        end
        it 'should destroy 1 questions_nodes_users' do
          expect {
            @context_node1.destroy
          }.to change(ContextNode, :count).by(-1)
        end
        it 'should destroy 1 nodes_users' do
          expect {
            @context_node1.destroy
          }.to change(Node::UserNode, :count).by(-1)
        end
  
        it 'should destroy 0 link' do
          expect {
            @context_node1.destroy
          }.to change(Link::GlobalLink, :count).by(0)
        end
  
        it 'should destroy 1 context_link' do
          expect {
            @context_node1.destroy
          }.to change(ContextLink, :count).by(-1)
        end
  
        it 'should destroy 1 gl' do
          expect {
            @context_node1.destroy
          }.to change(Link::QuestionLink, :count).by(-1)
        end
  
        it 'should destroy 1 lu' do
          expect {
            @context_node1.destroy
          }.to change(Link::UserLink, :count).by(-1)
        end
  
        it 'update the caches' do
          @context_node2.reload.upvotes_count.should == 1
          @context_node2.user_node.reload.upvotes_count.should == 1
          @context_node2.question_node.reload.upvotes_count.should == 1
          @context_node2.node.reload.upvotes_count.should == 2
          @context_node1.destroy
          @context_node2.reload.upvotes_count.should == 0 
          @context_node2.user_node.reload.upvotes_count.should == 0
          @context_node2.question_node.reload.upvotes_count.should == 0
          @context_node2.node.reload.upvotes_count.should == 1
        end
      end
  
      context 'when the user has the link in another question' do
        before do
          @context_link2 = ContextLink.create(:user=>@user, :question => @question2, :node_from_id => @context_node1.node.id, :node_to_id => @context_node2.node.id, :value => 1)
        end
        it 'should destroy 0 node' do
          expect {
            @context_node1.destroy
          }.to change(Node::GlobalNode, :count).by(0)
        end
        it 'should destroy 1 questions_nodes' do
          expect {
            @context_node1.destroy
          }.to change(Node::QuestionNode, :count).by(-1)
        end
        it 'should destroy 1 questions_nodes_users' do
          expect {
            @context_node1.destroy
          }.to change(ContextNode, :count).by(-1)
        end
        it 'should destroy 0 nodes_users' do
          expect {
            @context_node1.destroy
          }.to change(Node::UserNode, :count).by(0)
        end
  
        it 'should destroy 0 link' do
          expect {
            @context_node1.destroy
          }.to change(Link::GlobalLink, :count).by(0)
        end
  
        it 'should destroy 1 context_link' do
          expect {
            @context_node1.destroy
          }.to change(ContextLink, :count).by(-1)
        end
  
        it 'should destroy 1 gl' do
          expect {
            @context_node1.destroy
          }.to change(Link::QuestionLink, :count).by(-1)
        end
  
        it 'should destroy 0 lu' do
          expect {
            @context_node1.destroy
          }.to change(Link::UserLink, :count).by(0)
        end
  
        it 'update the caches' do
          @context_node2.reload.upvotes_count.should == 1
          @context_node2.user_node.reload.upvotes_count.should == 1
          @context_node2.question_node.reload.upvotes_count.should == 1
          @context_node2.node.reload.upvotes_count.should == 1
          @context_node1.destroy
          @context_node2.reload.upvotes_count.should == 0 
          @context_node2.user_node.reload.upvotes_count.should == 1
          @context_node2.question_node.reload.upvotes_count.should == 0
          @context_node2.node.reload.upvotes_count.should == 1
        end
      end

      context 'when the user has another link in this question where the links share a node from' do
        before do
          @context_link2 = ContextLink.create(:user=>@user, :question => @question, :node_from_id => @context_node1.node.id, :node_to_id => @context_node3.node.id, :value => 1)
        end
        it 'should destroy 1 node (despite shared node from -- all on user)' do
          expect {
            @context_node1.destroy
          }.to change(Node::GlobalNode, :count).by(-1)
        end
        it 'should destroy 1 questions_nodes' do
          expect {
            @context_node1.destroy
          }.to change(Node::QuestionNode, :count).by(-1)
        end
        it 'should destroy 1 questions_nodes_users' do
          expect {
            @context_node1.destroy
          }.to change(ContextNode, :count).by(-1)
        end
        it 'should destroy 1 nodes_users' do
          expect {
            @context_node1.destroy
          }.to change(Node::UserNode, :count).by(-1)
        end
  
        it 'should destroy 1 link' do
          expect {
            @context_node1.destroy
          }.to change(Link::GlobalLink, :count).by(-2)
        end
  
        it 'should destroy 1 context_link' do
          expect {
            @context_node1.destroy
          }.to change(ContextLink, :count).by(-2)
        end
  
        it 'should destroy 1 context_link' do
          expect {
            @context_node1.destroy
          }.to change(Link::QuestionLink, :count).by(-2)
        end
  
        it 'should destroy 1 context_link' do
          expect {
            @context_node1.destroy
          }.to change(Link::UserLink, :count).by(-2)
        end
  
        it 'update the caches' do
          @context_node2.reload.upvotes_count.should == 1
          @context_node2.user_node.reload.upvotes_count.should == 1
          @context_node2.question_node.reload.upvotes_count.should == 1
          @context_node2.node.reload.upvotes_count.should == 1
          @context_node3.reload.upvotes_count.should == 1
          @context_node3.user_node.reload.upvotes_count.should == 1
          @context_node3.question_node.reload.upvotes_count.should == 1
          @context_node3.node.reload.upvotes_count.should == 1
          @context_node1.destroy
          @context_node2.reload.upvotes_count.should == 0 
          @context_node2.user_node.reload.upvotes_count.should == 0
          @context_node2.question_node.reload.upvotes_count.should == 0
          @context_node2.node.reload.upvotes_count.should == 0
          @context_node3.reload.upvotes_count.should == 0 
          @context_node3.user_node.reload.upvotes_count.should == 0
          @context_node3.question_node.reload.upvotes_count.should == 0
          @context_node3.node.reload.upvotes_count.should == 0
        end
      end
    end
  end
end
