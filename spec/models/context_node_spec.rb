require 'spec_helper'
require 'models/context_node_spec_helper'

describe ContextNode do
  describe ".update_text" do
    let(:user) {FactoryGirl.create(:user)}
    let(:question) {FactoryGirl.create(:question)}
    let(:group_one) {FactoryGirl.create(:group)}
    let(:group_two) {FactoryGirl.create(:group, :title => "thundercats")}
    let(:group_three) {FactoryGirl.create(:group, :title => "warriors")}
    let(:new_text) {'Some revised title'}
    let(:original_conclusion_status) {true}
    context "when there is only the context node" do
      let(:context_node) {ContextNode.create(:user=>user, :question=>question, :title => 'Title', :is_conclusion => original_conclusion_status)}
      before do
        context_node
        @conclusion_statuses = {
                                 :group_question_conclusions => {
                                                                  :includes_old => false,
                                                                  :includes_new => true
                                                                },
                                 :user_question_conclusions => {
                                                                  :includes_old => false,
                                                                  :includes_new => true
                                                               },
                                 :question_conclusions => {
                                                                  :includes_old => false,
                                                                  :includes_new => true
                                                          }
                               }
      end
      it_should_behave_like "a context_node correctly updating node text"
    end
    context "when there is a context node in two links" do
      let(:context_node) {ContextNode.create(:user=>user, :question=>question, :title => 'Title', :is_conclusion => original_conclusion_status)}
      let(:context_node2) {ContextNode.create(:user=>user, :question=>question, :title => 'Title2', :is_conclusion => original_conclusion_status)}
      let(:context_node3) {ContextNode.create(:user=>user, :question=>question, :title => 'Title3', :is_conclusion => original_conclusion_status)}
      before do
        p "THIS"
        group_one.users << user
        group_two.users << user
        @link1 = Link::UserLink::PositiveUserLink.create(:user=>user, :question => question, :global_node_to_id => context_node.global_node_id, :global_node_from_id => context_node2.global_node_id)
        @link2 = Link::UserLink::PositiveUserLink.create(:user=>user, :question => question, :global_node_to_id => context_node.global_node_id, :global_node_from_id => context_node3.global_node_id)
        @conclusion_statuses = {
                                 :group_question_conclusions => {
                                                                  :includes_old => false,
                                                                  :includes_new => true
                                                                },
                                 :user_question_conclusions => {
                                                                  :includes_old => false,
                                                                  :includes_new => true
                                                               },
                                 :question_conclusions => {
                                                                  :includes_old => false,
                                                                  :includes_new => true
                                                          }
                               }
        p "THIS2"
      end
      it_should_behave_like "a context_node correctly updating node text"
    end
  end

  shared_examples_for "a context node change correctly updating conclusions" do 
    it "should ensure the global node has the correct conclusion status in the question" do
      @context_node.question.concluding_nodes.should include @context_node.global_node if @is_question_conclusion
    end
    it "should ensure the global node has the correct conclusion status for the question and user" do
      @context_node.user.concluding_nodes(@context_node.question).should include @context_node.global_node if @is_question_user_conclusion
    end
    it "should ensure the global node has the correct conclusion status in the group" do
      #should come through users in group - no group in context
      @group.concluding_nodes(@context_node.question).should include @context_node.global_node if @is_question_group_conclusion
    end
  end

  context "old features" do
    before do
      @user = FactoryGirl.create(:user)
      @user_two = FactoryGirl.create(:user, :email => "test@email.com")
      @question = FactoryGirl.create(:question)
      @question2 = FactoryGirl.create(:question, :name => 'Aaa')
      @group = FactoryGirl.create(:group)
      @group2 = FactoryGirl.create(:group, :title=> 'Aaa')
    end

    describe 'setting is conclusion' do
      context 'when the context node is created as false' do
        before do
          @group.users << @user
          @conclusion_status = false
          @context_node = ContextNode.create(:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => @conclusion_status)
          @context_node_one = @context_node
          @is_question_conclusion = @conclusion_status
          @is_question_user_conclusion = @conclusion_status
          @is_question_group_conclusion = @conclusion_status
        end
        it_should_behave_like "a context node change correctly updating conclusions"
        context 'when a new context node for the qn is created as true' do
          before do
            @user = FactoryGirl.create(:user, :email => "test2@email.com")
      @group.users << @user
            @new_conclusion_status = true
            @context_node = ContextNode.create(:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => @new_conclusion_status)
            @is_question_conclusion = @conclusion_status
            @is_question_group_conclusion = @conclusion_status
            @is_question_user_conclusion = @new_conclusion_status
          end
          it_should_behave_like "a context node change correctly updating conclusions"
          context 'when the first node is destroyed' do
            before do
              @context_node_one.destroy
        @is_question_conclusion = @new_conclusion_status
        @is_question_group_conclusion = @new_conclusion_status
              @is_question_user_conclusion = @new_conclusion_status
            end
            it_should_behave_like "a context node change correctly updating conclusions"
          end
          context 'when the first user tries to recreate the same node' do
            context "with the same conclusion status" do
              it "should create nothing else and be invalid" do
                pending
              end
            end
            context "with a different conclusion status" do
              it "should create nothing else and be invalid" do
                pending
              end
            end
          end
          context 'when the first user changes their mind to true' do
            before do
              @context_node_one.set_conclusion!(@new_conclusion_status = true)
        @is_question_conclusion = @new_conclusion_status
        @is_question_group_conclusion = @new_conclusion_status
              @is_question_user_conclusion = @new_conclusion_status
            end
            it_should_behave_like "a context node change correctly updating conclusions"
          end
          context 'when another new context node for the qn is created as true' do
            before do
              @user = FactoryGirl.create(:user, :email => "test3@email.com")
        @group.users << @user
              @new_conclusion_status = true
              @context_node = ContextNode.create(:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => @new_conclusion_status)
        @is_question_conclusion = @new_conclusion_status
        @is_question_group_conclusion = @new_conclusion_status
              @is_question_user_conclusion = @new_conclusion_status
            end
            it_should_behave_like "a context node change correctly updating conclusions"
          end
        end
      end
      context 'when the context node is created as true' do
        before do
    @group.users << @user
          @conclusion_status = true
          @context_node = ContextNode.create(:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => @conclusion_status)
          @is_question_conclusion = @conclusion_status
          @is_question_group_conclusion = @conclusion_status
          @is_question_user_conclusion = @conclusion_status
        end
        it_should_behave_like "a context node change correctly updating conclusions"
        context 'when a new context node for the qn is created as false' do
          before do
            @user = FactoryGirl.create(:user, :email => "test4@email.com")
      @group.users << @user
            @new_conclusion_status = false
            @context_node = ContextNode.create(:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => @new_conclusion_status)
            @is_question_conclusion = @new_conclusion_status
            @is_question_group_conclusion = @new_conclusion_status
            @is_question_user_conclusion = @new_conclusion_status
          end
          it_should_behave_like "a context node change correctly updating conclusions"
        end
      end
      context 'when the context node is created as nil' do
        before do
          @conclusion_status = nil
          @context_node = ContextNode.create(:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => "")
          @is_question_conclusion = false
          @is_question_group_conclusion = false
          @is_question_user_conclusion = false
        end
        it_should_behave_like "a context node change correctly updating conclusions"
        context 'when a new context node for the qn is created as true' do
          before do
            @user = FactoryGirl.create(:user, :email => "test5@email.com")
      @group.users << @user
            @new_conclusion_status = true
            @context_node = ContextNode.create(:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => @new_conclusion_status)
            @is_question_conclusion = true
            @is_question_group_conclusion = true
            @is_question_user_conclusion = true
          end
          it_should_behave_like "a context node change correctly updating conclusions"
        end
      end
    end

    describe 'creation' do
      context 'when there is no existing node with title for question and user' do
        before do
          conclusion_status = true
          @node_state_hash = {
                               :context_node => {
                                                  :number_created => 1
                                                },
                               :global_node => {
                                                 :number_created => 1,
                                                 :number_existing => 1,
                                                 :users_count => 1,
                                                 :is_conclusion => true
                                               }
                             }
          @params = {:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => conclusion_status}
        end 
        it_should_behave_like 'context node creating nodes'
      end
      context 'when there is an existing node for different question and user' do
        before do
          conclusion_status = true
          @params = {:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => conclusion_status}
          ContextNode.create(@params)
          @node_state_hash = {
                               :context_node => {
                                                  :number_created => 1
                                                },
                               :global_node => {
                                                 :number_created => 0,
                                                 :number_existing => 1,
                                                 :users_count => 2,
                                                 :is_conclusion => true
                                               }
                             }
          @user = FactoryGirl.create(:user, :email=>"another@test.com")
          @question = FactoryGirl.create(:question, :name => 'Alex is pretty')
          @params = {:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => conclusion_status}
        end 
        it_should_behave_like 'context node creating nodes'
      end
      context 'when there is an existing node for user but different question' do
        before do
          conclusion_status = true
          @params = {:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => conclusion_status}
          ContextNode.create(@params)
          @node_state_hash = {
                               :context_node => {
                                                  :number_created => 1
                                                },
                               :global_node => {
                                                 :number_created => 0,
                                                 :number_existing => 1,
                                                 :users_count => 2,
                                                 :is_conclusion => true
                                               }
                             }
          @question = FactoryGirl.create(:question, :name => 'Alex is pretty')
          @params = {:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => conclusion_status}
        end 
        it_should_behave_like 'context node creating nodes'
      end
      context 'when there is an existing node for question where is conclusion is false but different user and is_conclusion is true' do
        before do
          conclusion_status = false
          @params = {:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => conclusion_status}
          ContextNode.create(@params)
          new_conclusion_status = true
          @node_state_hash = {
                               :context_node => {
                                                  :number_created => 1
                                                },
                               :global_node => {
                                                 :number_created => 0,
                                                 :number_existing => 1,
                                                 :users_count => 2,
                                                 :is_conclusion => conclusion_status
                                               }
                             }
          @user = FactoryGirl.create(:user, :email=>"another@test.com")
          @params = {:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => new_conclusion_status}
        end 
        it_should_behave_like 'context node creating nodes'
        context 'when there is a further existing node for the question but a different user who thinks the conclusion status is true' do
          before do
            conclusion_status = true
            @params = {:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => conclusion_status}
            ContextNode.create(@params)
            new_conclusion_status = true
            @node_state_hash = {
                                 :context_node => {
                                                    :number_created => 1
                                                  },
                                 :global_node => {
                                                   :number_created => 0,
                                                   :number_existing => 1,
                                                   :users_count => 3,
                                                   :is_conclusion =>new_conclusion_status 
                                                 }
                               }
            @user = FactoryGirl.create(:user, :email=>"new@test.com")
            @params = {:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => new_conclusion_status}
          end 
          it_should_behave_like 'context node creating nodes'
        end
      end
    end
    describe 'updating conclusion' do
      describe 'updating with no other context_nodes for qn' do
        before do
          @context_node = ContextNode.create(:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => false)
        end
        it "should update the is conclusion status in all locations" do
          @context_node.question.concluding_nodes.should_not include @context_node.global_node
          @context_node.set_conclusion! true
          @context_node.question.concluding_nodes.reload.should include @context_node.global_node
          @context_node.set_conclusion! ''
          @context_node.question.concluding_nodes.reload.should_not include @context_node.global_node
        end
      end
      describe 'updating with other context_nodes for qn' do
        before do
          @user2 = FactoryGirl.create(:user, :email=>"another@test.com")
          @context_node = ContextNode.create(:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => false)
          @context_node2 = ContextNode.create(:user=>@user2, :question=>@question, :title => 'Title', :is_conclusion => true)
        end
        it "should update the is conclusion status in all locations" do
          @context_node.question.concluding_nodes.should_not include @context_node.global_node
          @context_node2.question.concluding_nodes.should_not include @context_node2.global_node
          @context_node2.set_conclusion! true
          @context_node.question.concluding_nodes.reload.should_not include @context_node.global_node
          @context_node2.question.concluding_nodes.reload.should_not include @context_node2.global_node
          @context_node.set_conclusion! ''
          @context_node.question.concluding_nodes.reload.should include @context_node.global_node
          @context_node2.question.concluding_nodes.reload.should include @context_node2.global_node
          @context_node.set_conclusion! false
          @context_node.question.concluding_nodes.reload.should_not include @context_node.global_node
          @context_node2.question.concluding_nodes.reload.should_not include @context_node2.global_node
          @context_node.set_conclusion! true
          @context_node.question.concluding_nodes.reload.should include @context_node.global_node
          @context_node2.question.concluding_nodes.reload.should include @context_node2.global_node
        end
      end
      describe 'updating with another context node for another qn' do
        before do
          @context_node = ContextNode.create(:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => false)
          @context_node2 = ContextNode.create(:user=>@user, :question=>@question2, :title => 'Title', :is_conclusion => true)
        end
        context 'when existing nu' do
          it "should update the is conclusion status in all locations" do
            @context_node.question.concluding_nodes.should_not include @context_node.global_node
            @context_node2.question.concluding_nodes.should include @context_node2.global_node
            @context_node2.set_conclusion! true
            @context_node.question.concluding_nodes.reload.should_not include @context_node.global_node
            @context_node2.question.concluding_nodes.reload.should include @context_node2.global_node
            @context_node.set_conclusion! true
            @context_node.question.concluding_nodes.reload.should include @context_node.global_node
            @context_node2.question.concluding_nodes.reload.should include @context_node2.global_node
          end
        end
        context 'when no existing nu' do
          before do
            @user2 = FactoryGirl.create(:user, :email=>"another@test.com")
            @context_node3 = ContextNode.create(:user=>@user2, :question=>@question2, :title => 'Title', :is_conclusion => false)
          end
          it "should update the is conclusion status in all locations" do
            @context_node2.question.concluding_nodes.should_not include @context_node.global_node
            @context_node3.question.concluding_nodes.should_not include @context_node2.global_node
            @context_node3.set_conclusion! true
            @context_node3.question.concluding_nodes.reload.should include @context_node.global_node
            @context_node2.question.concluding_nodes.reload.should include @context_node2.global_node
          end
        end
      end
    end
    describe 'deletion' do
      context 'when there are no associated links' do
        describe 'when the question nodes question node user count is less than two (when there is only this user)' do
          before do
            context_node = ContextNode.create(:user=>@user, :title=>'Title', :question=>@question, :is_conclusion => false)
          end
          it 'should destroy 1 node' do
            expect {
              ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
            }.to change(Node::GlobalNode, :count).by(-1)
          end
          it 'should destroy 1 questions_nodes_users' do
            expect {
              ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
            }.to change(ContextNode, :count).by(-1)
          end
          it 'should destroy the node' do
            ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
            Node::GlobalNode.where(:title=>'Title')[0].should be_nil
          end
          it 'should destroy the question node user' do
            ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
            ContextNode.where(:title=>'Title', :question_id=>@question.id)[0].should be_nil
          end
          context 'with another user for the question node' do
            before do
              @user = FactoryGirl.create(:user, :email => "a@test.com")
              context_node = ContextNode.create(:user=>@user, :title=>'Title', :question=>@question, :is_conclusion => false)
            end
            it 'should destroy 0 global_nodes' do
              expect {
                ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
              }.to change(Node::GlobalNode, :count).by(0)
            end
            it 'should destroy 1 questions_nodes_users' do
              expect {
                ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
              }.to change(ContextNode, :count).by(-1)
            end
            it 'should update the caches' do
              ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
              gn = Node::GlobalNode.where(:title=>'Title')[0]
              gn.should_not be_nil
              gn.users_count.should == 1
            end
            it 'should not destroy the node and question node and should destroy the context_node' do
              @user_two = FactoryGirl.create(:user, :email=>"another@test.com")
              context_node = ContextNode.create(:user=>@user_two, :question=>@question, :title => 'Title', :is_conclusion => true)
              ContextNode.where(:user_id=>@user_two.id, :title=>'Title', :question_id=>@question.id, :is_conclusion => true).count.should == 1
              @user_three = FactoryGirl.create(:user, :email=>"another@test2.com")
              context_node = ContextNode.create(:user=>@user_three, :question=>@question, :title => 'Title', :is_conclusion => true)
              ContextNode.where(:user_id=>@user_three.id, :title=>'Title', :question_id=>@question.id, :is_conclusion => true).count.should == 1
              ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
              
              Node::GlobalNode.where(:title=>'Title')[0].should_not be_nil
              ContextNode.where(:title=>'Title', :user_id => @user.id, :question_id=>@question.id)[0].should be_nil
            end
          end
        end
      end
      describe 'with existing links' do
        before do
          @group.users << @user
          @context_node1 = ContextNode.create(:title => 'title', :question => @question, :user => @user)
          @context_node2 = ContextNode.create(:title => 'test', :question => @question, :user => @user)
          @context_node3 = ContextNode.create(:title => 'another', :question => @question, :user => @user)
          @context_link = Link::UserLink::PositiveUserLink.create(:user=>@user, :question => @question, :global_node_from_id => @context_node1.global_node.id, :global_node_to_id => @context_node2.global_node.id)
        end
        it 'should destroy 1 node' do
          expect {
            @context_node1.destroy
          }.to change(Node::GlobalNode, :count).by(-1)
        end
        it 'should destroy 1 questions_nodes_users' do
          expect {
            @context_node1.destroy
          }.to change(ContextNode, :count).by(-1)
        end
        it 'should destroy 1 link' do
          expect {
            @context_node1.destroy
          }.to change(Link::GlobalLink, :count).by(-1)
        end

        it 'should destroy 1 context_link' do
          expect {
            @context_node1.destroy
          }.to change(Link::GroupLink, :count).by(-1)
        end

        it 'should destroy 1 context_link' do
          expect {
            @context_node1.destroy
          }.to change(Link::UserLink, :count).by(-1)
        end

        it 'update the caches' do
          #@context_node2.reload.upvotes_count.should == 1
          @context_node2.global_node.reload.upvotes_count.should == 1
          @context_node1.destroy
          #@context_node2.reload.upvotes_count.should == 0 
          @context_node2.global_node.reload.upvotes_count.should == 0
        end
        
        context 'when another user has the link in this question' do
          before do
            @group.users << @user_two
            @context_link2 = Link::UserLink::PositiveUserLink.create(:user=>@user_two, :question => @question, :global_node_from_id => @context_node1.global_node.id, :global_node_to_id => @context_node2.global_node.id)
          end
          it 'should destroy 0 node' do
            expect {
              @context_node1.destroy
            }.to change(Node::GlobalNode, :count).by(0)
          end
          it 'should destroy 1 questions_nodes_users' do
            expect {
              @context_node1.destroy
            }.to change(ContextNode, :count).by(-1)
          end
          it 'should destroy 0 link' do
            expect {
              @context_node1.destroy
            }.to change(Link::GlobalLink, :count).by(0)
          end
    
          it 'should destroy 0 gl' do
            expect {
              @context_node1.destroy
            }.to change(Link::GroupLink, :count).by(0)
          end
    
          it 'should destroy 1 lu' do
            expect {
              @context_node1.destroy
            }.to change(Link::UserLink, :count).by(-1)
          end
    
          it 'update the caches' do
            #@context_node2.reload.upvotes_count.should == 1
            @context_node2.global_node.reload.upvotes_count.should == 2
            @context_node1.destroy
            #@context_node2.reload.upvotes_count.should == 0 
            @context_node2.global_node.reload.upvotes_count.should == 1
          end
        end
    
        context 'when another user has another link in this question which uses the same node from' do
          before do
            @group.users << @user
            @context_link2 = Link::UserLink::PositiveUserLink.create(:user=>@user_two, :question => @question, :global_node_from_id => @context_node1.global_node.id, :global_node_to_id => @context_node3.global_node.id)
          end
          it 'should destroy 0 node (due to shared node from and diff users)' do
            expect {
              @context_node1.destroy
            }.to change(Node::GlobalNode, :count).by(0)
          end
          it 'should destroy 1 questions_nodes_users' do
            expect {
              @context_node1.destroy
            }.to change(ContextNode, :count).by(-1)
          end
    
          it 'should destroy 1 link' do
            expect {
              @context_node1.destroy
            }.to change(Link::GlobalLink, :count).by(-1)
          end
    
          it 'should destroy 1 gl' do
            expect {
              @context_node1.destroy
            }.to change(Link::GroupLink, :count).by(-1)
          end
    
          it 'should destroy 1 lu' do
            expect {
              @context_node1.destroy
            }.to change(Link::UserLink, :count).by(-1)
          end
    
          it 'update the caches' do
            #@context_node2.reload.upvotes_count.should == 1
            @context_node2.global_node.reload.upvotes_count.should == 1
            @context_node1.destroy
            #@context_node2.reload.upvotes_count.should == 0 
            @context_node2.global_node.reload.upvotes_count.should == 0
          end
        end
    
        context 'when another user has the link in another question' do
          before do
            @group2.users << @user_two
            @context_link2 = Link::UserLink::PositiveUserLink.create(:user=>@user_two, :question => @question2, :global_node_from_id => @context_node1.global_node.id, :global_node_to_id => @context_node2.global_node.id)
          end
          it 'should destroy 0 node' do
            expect {
              @context_node1.destroy
            }.to change(Node::GlobalNode, :count).by(0)
          end
          it 'should destroy 1 questions_nodes_users' do
            expect {
              @context_node1.destroy
            }.to change(ContextNode, :count).by(-1)
          end
    
          it 'should destroy 0 link' do
            expect {
              @context_node1.destroy
            }.to change(Link::GlobalLink, :count).by(0)
          end
    
          it 'should destroy 1 gl' do
            expect {
              @context_node1.destroy
            }.to change(Link::GroupLink, :count).by(-1)
          end
    
          it 'should destroy 1 lu' do
            expect {
              @context_node1.destroy
            }.to change(Link::UserLink, :count).by(-1)
          end
    
          it 'update the caches' do
            #@context_node2.reload.upvotes_count.should == 1
            @context_node2.global_node.reload.upvotes_count.should == 2
            @context_node1.destroy
            #@context_node2.reload.upvotes_count.should == 0 
            @context_node2.global_node.reload.upvotes_count.should == 1
          end
        end
    
        context 'when the user has the link in another question' do
          before do
            @user.groups << @group2
            @context_link2 = Link::UserLink::PositiveUserLink.create(:user=>@user, :question => @question2, :global_node_from_id => @context_node1.global_node.id, :global_node_to_id => @context_node2.global_node.id)
          end
          it 'should destroy 0 node' do
            expect {
              @context_node1.destroy
            }.to change(Node::GlobalNode, :count).by(0)
          end
          it 'should destroy 1 questions_nodes_users' do
            expect {
              @context_node1.destroy
            }.to change(ContextNode, :count).by(-1)
          end
    
          it 'should destroy 0 link' do
            expect {
              @context_node1.destroy
            }.to change(Link::GlobalLink, :count).by(-1)
          end
    
          it 'should destroy 1 gl' do
            expect {
              @context_node1.destroy
            }.to change(Link::GroupLink, :count).by(-2)
          end
    
          it 'should destroy 1 lu' do
            expect {
              @context_node1.destroy
            }.to change(Link::UserLink, :count).by(-1)
          end
    
          it 'update the caches' do
            #@context_node2.reload.upvotes_count.should == 1
            @context_node2.global_node.reload.upvotes_count.should == 1
            @context_node1.destroy
            #@context_node2.reload.upvotes_count.should == 0 
            @context_node2.global_node.reload.upvotes_count.should == 0
          end
        end

        context 'when the user has another link in this question where the links share a node from' do
          before do
            @group.users << @user
            @context_link2 = Link::UserLink::PositiveUserLink.create(:user=>@user, :question => @question, :global_node_from_id => @context_node1.global_node.id, :global_node_to_id => @context_node3.global_node.id)
          end
          it 'should destroy 1 node (despite shared node from -- all on user)' do
            expect {
              @context_node1.destroy
            }.to change(Node::GlobalNode, :count).by(-1)
          end
          it 'should destroy 1 questions_nodes_users' do
            expect {
              @context_node1.destroy
            }.to change(ContextNode, :count).by(-1)
          end
    
          it 'should destroy 1 link' do
            expect {
              @context_node1.destroy
            }.to change(Link::GlobalLink, :count).by(-2)
          end
    
          it 'should destroy 1 context_link' do
            expect {
              @context_node1.destroy
            }.to change(Link::GroupLink, :count).by(-2)
          end
    
          it 'should destroy 1 context_link' do
            expect {
              @context_node1.destroy
            }.to change(Link::UserLink, :count).by(-2)
          end
    
          it 'update the caches' do
            #@context_node2.reload.upvotes_count.should == 1
            @context_node2.global_node.reload.upvotes_count.should == 1
            #@context_node3.reload.upvotes_count.should == 1
            @context_node3.global_node.reload.upvotes_count.should == 1
            @context_node1.destroy
            #@context_node2.reload.upvotes_count.should == 0 
            @context_node2.global_node.reload.upvotes_count.should == 0
            #@context_node3.reload.upvotes_count.should == 0 
            @context_node3.global_node.reload.upvotes_count.should == 0
          end
        end
      end
    end
    describe 'it should not delete the links for other questions - do not delete cl, delete ugl? or uql down..?' do
      it 'should be sensible' do
        pending
      end
    end
  end
end
