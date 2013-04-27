require 'spec_helper'
require 'random_link_map'
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
      let(:context_node) {Node::UserNode.create(:user=>user, :question=>question, :title => 'Title', :is_conclusion => original_conclusion_status)}
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
      let(:context_node) {Node::UserNode.create(:user=>user, :question=>question, :title => 'Title', :is_conclusion => original_conclusion_status)}
      let(:context_node2) {Node::UserNode.create(:user=>user, :question=>question, :title => 'Title2', :is_conclusion => original_conclusion_status)}
      let(:context_node3) {Node::UserNode.create(:user=>user, :question=>question, :title => 'Title3', :is_conclusion => original_conclusion_status)}
      before do
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
      end
      #it_should_behave_like "a context_node correctly updating node text"
    end
    context "when there are many many links and nodes and such" do
      let(:link_map) {RandomLinkMap.new( {
                                       :question_count => 5,
                                       :user_count => 5,
                                       :group_count => 5,
                                       :node_count => 20,
                                       :link_count_per_node => 20
                                      }, true)}
      let(:context_node) {ContextNode.find(link_map.nodes.last)}
      #before {link_map}
      #it_should_behave_like "a context_node correctly updating node text"
    end
  end

  shared_examples_for "a context node change correctly updating conclusions" do 
    it "should ensure the global node has the correct conclusion status in the question" do
      @context_node.question.concluding_nodes.should include @context_node.global_node if @is_question_conclusion
    end
    it "should ensure the global node has the correct conclusion status for the question and user" do
      @context_node.user.concluding_nodes(@question).should include @context_node.global_node if @is_question_user_conclusion
    end
    it "should ensure the global node has the correct conclusion status in the group" do
      #should come through users in group - no group in context
      @group.concluding_nodes(@question).should include @context_node.global_node if @is_question_group_conclusion
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
          @params = {:user_id=>@user.id, :question_id=>@question.id, :title => 'Title', :is_conclusion => @conclusion_status}
          @context_node = Node::UserNode.create(@params)
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
            @params2 = {:user_id=>@user.id, :question_id=>@question.id, :title => 'Title', :is_conclusion => @new_conclusion_status}
            @context_node = Node::UserNode.create(@params2)
            @is_question_conclusion = @conclusion_status
            @is_question_group_conclusion = @conclusion_status
            @is_question_user_conclusion = @new_conclusion_status
          end
          it_should_behave_like "a context node change correctly updating conclusions"
          context 'when the first node is destroyed' do
            before do
              context_node = ContextNode.where(@params.except(:is_conclusion))[0]
              context_node.destroy
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
              context_node = ContextNode.where(@params.except(:is_conclusion))[0]
              context_node.set_conclusion!(@new_conclusion_status = true)
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
              @context_node = Node::UserNode.create(:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => @new_conclusion_status)
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
          @context_node = Node::UserNode.create(:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => @conclusion_status)
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
            @context_node = Node::UserNode.create(:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => @new_conclusion_status)
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
          @context_node = Node::UserNode.create(:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => "")
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
            @context_node = Node::UserNode.create(:user=>@user, :question=>@question, :title => 'Title', :is_conclusion => @new_conclusion_status)
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
                               :user_node => {
                                                  :number_created => 1
                                                },
                               :global_node => {
                                                 :number_created => 1,
                                                 :number_existing => 1,
                                                 :users_count => 1,
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
          Node::UserNode.create(@params)
          @node_state_hash = {
                               :context_node => {
                                                  :number_created => 1
                                                },
                               :user_node => {
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
          Node::UserNode.create(@params)
          @node_state_hash = {
                               :context_node => {
                                                  :number_created => 1
                                                },
                               :user_node => {
                                                  :number_created => 0
                                                },
                               :global_node => {
                                                 :number_created => 0,
                                                 :number_existing => 1,
                                                 :users_count => 1
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
          Node::UserNode.create(@params)
          new_conclusion_status = true
          @node_state_hash = {
                               :context_node => {
                                                  :number_created => 1
                                                },
                               :user_node => {
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
            Node::UserNode.create(@params)
            new_conclusion_status = true
            @node_state_hash = {
                                 :context_node => {
                                                    :number_created => 1
                                                  },
                               :user_node => {
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
        let(:cn_params) {{:user_id=>@user.id, :question_id=>@question.id, :title => 'Title', :is_conclusion => false}}
        before do
          @un = Node::UserNode.create!(cn_params)
        end
        it "should update the is conclusion status in all locations" do
          cn = ContextNode.where(cn_params.merge({:user_node_id => @un.id}))[0]
	        cn.question.concluding_nodes.reload.should_not include cn.global_node
          cn.set_conclusion! true
          cn.question.concluding_nodes.reload.should include cn.global_node
          cn.set_conclusion! ''
          cn.question.concluding_nodes.reload.should_not include cn.global_node
        end
      end
      describe 'updating with other context_nodes for qn' do
        let(:cn_params) {{:user_id=>@user.id, :question_id=>@question.id, :title => 'Title', :is_conclusion => false}}
	let(:user2) {FactoryGirl.create(:user, :email=>"another@test.com")}
	let(:cn_params2) {{:user_id=>user2.id, :question_id=>@question.id, :title => 'Title', :is_conclusion => true}}
        before do
          @un = Node::UserNode.create(cn_params)
          @un2 = Node::UserNode.create(cn_params2)
        end
        it "should update the is conclusion status in all locations" do
          cn = ContextNode.where(cn_params.merge(user_node_id:@un.id))[0]
	  cn2 = ContextNode.where(cn_params2.merge(user_node_id:@un2.id))[0]
	  cn.question.concluding_nodes.reload.should_not include cn.global_node
          cn2.question.concluding_nodes.reload.should_not include cn2.global_node
          cn2.set_conclusion! true
          cn.question.concluding_nodes.reload.should_not include cn.global_node
          cn2.question.concluding_nodes.reload.should_not include cn2.global_node
          cn.set_conclusion! ''
          cn.question.concluding_nodes.reload.should include cn.global_node
          cn2.question.concluding_nodes.reload.should include cn2.global_node
          cn.set_conclusion! false
          cn.question.concluding_nodes.reload.should_not include cn.global_node
          cn2.question.concluding_nodes.reload.should_not include cn2.global_node
          cn.set_conclusion! true
          cn.question.concluding_nodes.reload.should include cn.global_node
          cn2.question.concluding_nodes.reload.should include cn2.global_node
        end
      end
      describe 'updating with another context node for another qn' do
        let(:cn_params) {{:user_id=>@user.id, :question_id=>@question.id, :title => 'Title', :is_conclusion => false}}
	let(:cn_params2) {{:user_id=>@user.id, :question_id=>@question2.id, :title => 'Title', :is_conclusion => true}}
        before do
          @un = Node::UserNode.create(cn_params)
          @un2 = Node::UserNode.create(cn_params2)
        end
        context 'when existing nu' do
          it "should update the is conclusion status in all locations" do
            cn = ContextNode.where(cn_params.merge(user_node_id:@un.id))[0]
            cn2= ContextNode.where(cn_params2.merge(user_node_id:@un2.id))[0]
            cn.question.concluding_nodes.should_not include cn.global_node
            cn2.question.concluding_nodes.should include cn2.global_node
            cn2.set_conclusion! true
            cn.question.concluding_nodes.reload.should_not include cn.global_node
            cn2.question.concluding_nodes.reload.should include cn2.global_node
            cn.set_conclusion! true
            cn.question.concluding_nodes.reload.should include cn.global_node
            cn2.question.concluding_nodes.reload.should include cn2.global_node
          end
        end
        context 'when no existing nu' do
          let(:user2) {FactoryGirl.create(:user, :email=>"another@test.com")}
	  let(:cn_params3) {{:user_id=>user2.id, :question_id=>@question2.id, :title => 'Title', :is_conclusion => false}}
          before do
            @un3 = Node::UserNode.create(cn_params3)
          end
          it "should update the is conclusion status in all locations" do
            cn = ContextNode.where(cn_params.merge(user_node_id:@un.id))[0]
            cn2= ContextNode.where(cn_params2.merge(user_node_id:@un2.id))[0]
            cn3= ContextNode.where(cn_params3.merge(user_node_id:@un3.id))[0]
            cn2.question.concluding_nodes.should_not include cn.global_node
            cn3.question.concluding_nodes.should_not include cn2.global_node
            cn3.set_conclusion! true
            cn3.question.concluding_nodes.reload.should include cn.global_node
            cn2.question.concluding_nodes.reload.should include cn2.global_node
          end
        end
      end
    end
    describe 'deletion' do
      context 'when there are no associated links' do
        describe 'when the question nodes question node user count is less than two (when there is only this user)' do
          before do
            @create_params = {:user_id=>@user.id, :title=>'Title', :question_id=>@question.id, :is_conclusion => false}
            @node = Node::UserNode.create(@create_params)
            @perform = "ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0]"

            @state_hash = {
                     :context_node => {
                                        :destroyed => -1
                                      },
                     :global_node => {
                                       :destroyed => -1
                                     },
                     :user_node => {
                                       :destroyed => -1
                                     }
                   }
          end
          it_should_behave_like "a node deleting nodes correctly"
          context 'with another context node for this user and title' do
            before do
              @question2 = FactoryGirl.create(:question, :name => 'Abbaa')
              @create_params = {:user_id=>@user.id, :title=>'Title', :question_id=>@question2.id, :is_conclusion => false}
              @node = Node::UserNode.create(@create_params)
              @perform = "ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question2.id)[0]"

              @state_hash = {
                       :context_node => {
                                          :destroyed => -1
                                        },
                       :global_node => {
                                         :destroyed => 0,
                                         :users_count => 1
                                       },
                       :user_node => {
                                         :destroyed => 0
                                       }
                     }
            end
            it_should_behave_like "a node deleting nodes correctly"
          end
          context 'with another user for the question node' do
            before do
              @user2 = FactoryGirl.create(:user, :email => "a@test.com")
              @create_params = {:user_id=>@user2.id, :title=>'Title', :question_id=>@question.id, :is_conclusion => false}
              @node = Node::UserNode.create(@create_params)
              @perform = "ContextNode.where(:user_id=>@user2.id, :title=>'Title', :question_id=>@question.id)[0]"

              @state_hash = {
                       :context_node => {
                                          :destroyed => -1
                                        },
                       :global_node => {
                                         :destroyed => 0,
                                         :users_count => 1
                                       },
                       :user_node => {
                                         :destroyed => -1
                                       }
                     }
            end
            it_should_behave_like "a node deleting nodes correctly"
          end
        end
      end
      context "when perform is user node delete" do
        it "should" do
          pending
        end
      end
    end
  end
  it "should have a test for deleting context not when last one, which deletes user node (not user node deleting context node) which deletes links" do
    pending
  end
  it "should not store is conclusion on user node" do
    pending
  end
  it "should delete db cruft and remove sti as much as possible" do
    pending
  end
end
