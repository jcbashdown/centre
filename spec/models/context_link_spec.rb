require 'spec_helper'

describe ContextLink do
  describe 'create' do
    context 'when there is no existing context_link' do
      before do
        @question = FactoryGirl.create(:question)
        @user = FactoryGirl.create(:user)
        @gnu1 = ContextNode.create(:title => 'title', :question => @question, :user => @user)
        @gnu2 = ContextNode.create(:title => 'test', :question => @question, :user => @user)
      end
      it 'should create a context_link' do
        expect {
          ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        }.to change(ContextLink, :count).by(1)
      end
      it 'should create the context_link' do
        context_link = ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        context_link.should be_persisted
        context_link = ContextLink::PositiveContextLink.where(:user_id=>@user.id, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id, :question_id=>@question.id).count.should == 1
      end
      it 'should create a ql' do
        expect {
          ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        }.to change(Link::QuestionLink::PositiveQuestionLink, :count).by(1)
      end
      it 'should create the ql' do
        context_link = ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        context_link.question_link.should be_persisted
        context_link.question_link.should be_a(Link::QuestionLink::PositiveQuestionLink)
        context_link.question_link.reload.users_count.should == 1
      end
      it 'should create an lu' do
        expect {
          ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        }.to change(Link::UserLink::PositiveUserLink, :count).by(1)
      end
      it 'should create the lu' do
        context_link = ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        context_link.user_link.should be_persisted
        context_link.user_link.should be_a(Link::UserLink::PositiveUserLink)
        context_link.user_link.reload.users_count.should == 1
      end
      it 'should create an l' do
        expect {
          ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        }.to change(Link::GlobalLink::PositiveGlobalLink, :count).by(1)
      end
      it 'should create the l' do
        context_link = ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        context_link.global_link.should be_persisted
        context_link.global_link.should be_a(Link::GlobalLink::PositiveGlobalLink)
        context_link.global_link.reload.users_count.should == 1
      end
      it 'should create the gnus and increment the votes' do
        Rails.logger.info "make stuff"
        context_link = ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        Rails.logger.info "make stuff"
        context_link.context_node_from.should be_persisted
        context_link.context_node_from.should be_a(ContextNode)
        context_link.context_node_from.reload.context_links_count.should == 1
        context_link.context_node_to.should be_persisted
        context_link.context_node_to.should be_a(ContextNode)
        context_link.context_node_to.reload.context_links_count.should == 1
      end
      it 'should increment the votes on the n' do
        ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        node_to = Node::GlobalNode.where(:id => @gnu2.global_node.id)[0]
        node_to.upvotes_count.should == 1
        node_from = Node::GlobalNode.where(:id => @gnu1.global_node.id)[0]
        node_from.should_not be_nil
        node_from.upvotes_count.should == 0 
      end
      it 'should increment the votes on the gn' do
        ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        node_to = Node::QuestionNode.where(:node_title_id => @gnu2.node_title_id, :question_id => @question.id)[0]
        node_to.upvotes_count.should == 1
        node_from = Node::QuestionNode.where(:node_title_id => @gnu1.node_title_id, :question_id => @question.id)[0]
        node_from.should_not be_nil
        node_from.upvotes_count.should == 0
      end
      it 'should register the vote on nu' do
        ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        node_to = Node::UserNode.where(:node_title_id => @gnu2.node_title_id, :user_id => @user.id)[0]
        node_to.upvotes_count.should == 1
        node_from = Node::UserNode.where(:node_title_id => @gnu1.node_title_id, :user_id => @user.id)[0]
        node_from.should_not be_nil
        node_from.upvotes_count.should == 0 
      end
      context 'when creating a duplicate context_link' do
        before do
          ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        end
        it 'should create a context_link' do
          expect {
            ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
          }.to change(ContextLink, :count).by(0)
        end
        it 'should create the context_link' do
          ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
          context_link = ContextLink::PositiveContextLink.where(:user_id=>@user.id, :question_id => @question.id, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)[0]
          context_link.should be_persisted
          context_link = ContextLink::PositiveContextLink.where(:user_id=>@user.id, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id, :question_id=>@question.id).count .should == 1
        end
        it 'should create a gl' do
          expect {
            ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
          }.to change(Link::GlobalLink, :count).by(0)
        end
        it 'should create the gl' do
          ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
          context_link = ContextLink::PositiveContextLink.where(:user_id=>@user.id, :question_id => @question.id, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)[0]
          context_link.global_link.should be_persisted
          context_link.global_link.should be_a(Link::GlobalLink)
          context_link.global_link.reload.users_count.should == 1
        end
        it 'should create an lu' do
          expect {
            ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
          }.to change(Link::UserLink, :count).by(0)
        end
        it 'should create the lu' do
          ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
          context_link = ContextLink::PositiveContextLink.where(:user_id=>@user.id, :question_id => @question.id, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)[0]
          context_link.user_link.should be_persisted
          context_link.user_link.should be_a(Link::UserLink)
          context_link.user_link.reload.users_count.should == 1
        end
        it 'should create an l' do
          expect {
            ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
          }.to change(Link, :count).by(0)
        end
        it 'should create the l' do
          ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
          context_link = ContextLink::PositiveContextLink.where(:user_id=>@user.id, :question_id => @question.id, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)[0]
          context_link.global_link.should be_persisted
          context_link.global_link.should be_a(Link)
          context_link.global_link.reload.users_count.should == 1
        end
        it 'should create the gnus and increment the votes' do
          ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
          context_link = ContextLink::PositiveContextLink.where(:user_id=>@user.id, :question_id => @question.id, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)[0]
          context_link.context_node_from.should be_persisted
          context_link.context_node_from.should be_a(ContextNode)
          context_link.context_node_from.reload.context_links_count.should == 1
          context_link.context_node_to.should be_persisted
          context_link.context_node_to.should be_a(ContextNode)
          context_link.context_node_to.reload.context_links_count.should == 1
        end
        it 'should increment the votes on the n' do
          ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
          node_to = Node::GlobalNode.where(:id => @gnu2.global_node.id)[0]
          node_to.upvotes_count.should == 1
          node_from = Node::GlobalNode.where(:id => @gnu1.global_node.id)[0]
          node_from.should_not be_nil
          node_from.upvotes_count.should == 0 
        end
        it 'should increment the votes on the gn' do
          ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
          node_to = Node::QuestionNode.where(:node_title_id => @gnu2.node_title_id, :question_id => @question.id)[0]
          node_to.upvotes_count.should == 1
          node_from = Node::QuestionNode.where(:node_title_id => @gnu1.node_title_id, :question_id => @question.id)[0]
          node_from.should_not be_nil
          node_from.upvotes_count.should == 0
        end
        it 'should register the vote on nu' do
          ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
          node_to = Node::UserNode.where(:node_title_id => @gnu2.node_title_id, :user_id => @user.id)[0]
          node_to.upvotes_count.should == 1
          node_from = Node::UserNode.where(:node_title_id => @gnu1.node_title_id, :user_id => @user.id)[0]
          node_from.should_not be_nil
          node_from.upvotes_count.should == 0 
        end
      end
    end
    context 'when creating equivalents' do
      before do
        @question = FactoryGirl.create(:question)
        @user = FactoryGirl.create(:user)
        @gnu1 = ContextNode.create(:title => 'title', :question => @question, :user => @user)
        @gnu2 = ContextNode.create(:title => 'test', :question => @question, :user => @user)
      end
      it 'should create a context_link' do
        expect {
          ContextLink::EquivalentContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        }.to change(ContextLink, :count).by(1)
      end
      it 'should create the context_link' do
        context_link = ContextLink::EquivalentContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        context_link.should be_persisted
        context_link = ContextLink::EquivalentContextLink.where(:user_id=>@user.id, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id, :question_id=>@question.id).count .should == 1
      end
      it 'should create a gl' do
        expect {
          ContextLink::EquivalentContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        }.to change(Link::GlobalLink, :count).by(1)
      end
      it 'should create the gl' do
        context_link = ContextLink::EquivalentContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        context_link.global_link.should be_persisted
        context_link.global_link.should be_a(Link::GlobalLink)
        context_link.global_link.reload.users_count.should == 1
      end
      it 'should create an lu' do
        expect {
          ContextLink::EquivalentContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        }.to change(Link::UserLink, :count).by(1)
      end
      it 'should create the lu' do
        context_link = ContextLink::EquivalentContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        context_link.user_link.should be_persisted
        context_link.user_link.should be_a(Link::UserLink)
        context_link.user_link.reload.users_count.should == 1
      end
      it 'should create an l' do
        expect {
          ContextLink::EquivalentContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        }.to change(Link::GlobalLink, :count).by(1)
      end
      it 'should create the l' do
        context_link = ContextLink::EquivalentContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        context_link.global_link.should be_persisted
        context_link.global_link.should be_a(Link::GlobalLink)
        context_link.global_link.reload.users_count.should == 1
      end
      it 'should create the gnus and increment the votes' do
        context_link = ContextLink::EquivalentContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        context_link.context_node_from.should be_persisted
        context_link.context_node_from.should be_a(ContextNode)
        context_link.context_node_from.reload.context_links_count.should == 1
        context_link.context_node_to.should be_persisted
        context_link.context_node_to.should be_a(ContextNode)
        context_link.context_node_to.reload.context_links_count.should == 1
      end
      it 'should increment the votes on the n' do
        ContextLink::EquivalentContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        node_to = Node::GlobalNode.where(:id => @gnu2.global_node.id)[0]
        #node_to.equivalents_count.should == 1
        node_from = Node::GlobalNode.where(:id => @gnu1.global_node.id)[0]
        node_from.should_not be_nil
        #node_from.equivalents_count.should == 1
      end
      it 'should increment the votes on the gn' do
        ContextLink::EquivalentContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        node_to = Node::QuestionNode.where(:node_title_id => @gnu2.node_title_id, :question_id => @question.id)[0]
        #node_to.equivalents_count.should == 1
        node_from = Node::QuestionNode.where(:node_title_id => @gnu1.node_title_id, :question_id => @question.id)[0]
        node_from.should_not be_nil
        #node_from.equivalents_count.should == 1
      end
      it 'should register the vote on nu' do
        ContextLink::EquivalentContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        node_to = Node::UserNode.where(:node_title_id => @gnu2.node_title_id, :user_id => @user.id)[0]
        #node_to.equivalents_count.should == 1
        node_from = Node::UserNode.where(:node_title_id => @gnu1.node_title_id, :user_id => @user.id)[0]
        node_from.should_not be_nil
        #node_from.equivalents_count.should == 1
      end
    end
  end

  describe 'destroy' do
    before do
      @question = FactoryGirl.create(:question)
      @user = FactoryGirl.create(:user)
      @gnu1 = ContextNode.create(:title => 'title', :question => @question, :user => @user)
      @gnu2 = ContextNode.create(:title => 'test', :question => @question, :user => @user)
    end
    context 'when there is only this context_link' do
      before do
        @context_link = ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        @context_link_attrs = @context_link.attributes
        @lu_attrs = {:node_from_id => @context_link.user_node_from.id, :node_to_id => @context_link.user_node_to.id, :user_id => @user.id}
        @gl_attrs = {:node_from_id => @context_link.question_node_from.id, :node_to_id => @context_link.question_node_to.id, :question_id => @question.id}
      end
      it 'should destroy the context_link' do
        ContextLink::PositiveContextLink.where(@context_link_attrs)[0].should_not be_nil
        @context_link.destroy
        ContextLink::PositiveContextLink.where(@context_link_attrs)[0].should be_nil
      end

      it 'should decrement the context_links count by 1' do
        expect {
          @context_link.destroy
        }.to change(ContextLink, :count).by(-1)
      end

      it 'should destroy the gl' do
        Link::QuestionLink.where(@gl_attrs)[0].should_not be_nil
        @context_link.destroy
        Link::QuestionLink.where(@gl_attrs)[0].should be_nil
      end

      it 'should decrement the gl count by 1' do
        expect {
          @context_link.destroy
        }.to change(Link::QuestionLink, :count).by(-1)
      end

      it 'should destroy the lu' do
        Link::UserLink.where(@lu_attrs)[0].should_not be_nil
        @context_link.destroy
        Link::UserLink.where(@lu_attrs)[0].should be_nil
      end

      it 'should decrement the lu count by 1' do
        expect {
          @context_link.destroy
        }.to change(Link::UserLink, :count).by(-1)
      end
      
      it 'should update the caches' do
        @gnu2.global_node.reload.upvotes_count.should == 1
        @context_link.destroy
        @gnu2.global_node.reload.upvotes_count.should == 0
      end
    end
    context 'when there is this context_link and another for a different global' do
      before do
        @question_two = FactoryGirl.create(:question, :name => 'test global')
        @context_link = ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        @context_link_attrs = @context_link.attributes
        @lu_attrs = {:node_from_id => @context_link.user_node_from.id, :node_to_id => @context_link.user_node_to.id, :user_id => @user.id}
        @gl_attrs = {:node_from_id => @context_link.question_node_from.id, :node_to_id => @context_link.question_node_to.id, :question_id => @question.id}
        Link::UserLink.where(@lu_attrs)[0].users_count.should == 1 
        @context_link_two = ContextLink::PositiveContextLink.create(:user=>@user, :question => @question_two, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        Link::UserLink.count.should == 1
        Link::UserLink.where(@lu_attrs)[0].users_count.should == 2 
      end
      it 'should destroy the context_link' do
        ContextLink::PositiveContextLink.where(@context_link_attrs)[0].should_not be_nil
        @context_link.destroy
        ContextLink::PositiveContextLink.where(@context_link_attrs)[0].should be_nil
      end

      it 'should decrement the context_links count by 1' do
        expect {
          @context_link.destroy
        }.to change(ContextLink, :count).by(-1)
      end

      it 'should destroy the gl' do
        Link::QuestionLink.where(@gl_attrs)[0].should_not be_nil
        @context_link.destroy
        Link::QuestionLink.where(@gl_attrs)[0].should be_nil
      end

      it 'should decrement the gl count by 1' do
        expect {
          @context_link.destroy
        }.to change(Link::QuestionLink, :count).by(-1)
      end

      it 'should decrement the lus context_link count by 1' do
        Link::UserLink.count.should == 1
        Link::UserLink.where(@lu_attrs)[0].users_count.should == 2
        @context_link.destroy
        Link::UserLink.count.should == 1
        Link::UserLink.where(@lu_attrs)[0].users_count.should == 1 
      end

      it 'should not destroy the lu' do
        Link::UserLink.where(@lu_attrs)[0].should_not be_nil
        @context_link.destroy
        Link::UserLink.where(@lu_attrs)[0].should_not be_nil
      end

      it 'should not decrement the lu count' do
        expect {
          @context_link.destroy
        }.to change(Link::UserLink, :count).by(0)
      end
      
      it 'should update the caches' do
        node_to = Node::GlobalNode.where(:title => @gnu2.global_node.title)[0]
        gnu_to = ContextNode.where(:question_id => @question.id, :node_title_id => @gnu2.node_title_id, :user_id => @user.id)[0]
        gn_to = Node::QuestionNode.where(:question_id => @question.id, :node_title_id => @gnu2.node_title_id)[0]
        nu_to = Node::UserNode.where(:node_title_id => @gnu2.node_title_id, :user_id => @user.id)[0]
        gn_to.upvotes_count.should == 1
        nu_to.upvotes_count.should == 1 
        node_to.upvotes_count.should == 1 
        @context_link.destroy
        node_to = Node.where(:title => @gnu2.global_node.title)[0]
        gnu_to = GlobalNodeUser.where(:question_id => @question.id, :node_title_id => @gnu2.node_title_id, :user_id => @user.id)[0]
        gn_to = Node::QuestionNode.where(:question_id => @question.id, :node_title_id => @gnu2.node_title_id)[0]
        nu_to = Node::UserNode.where(:node_title_id => @gnu2.node_title_id, :user_id => @user.id)[0]
        gn_to.upvotes_count.should == 0
        nu_to.upvotes_count.should == 1 
        node_to.reload.upvotes_count.should == 1 
      end
    end
    context 'when there is this context_link and another for a different user' do
      before do
        @user_two = FactoryGirl.create(:user, :email => "test@user.com")
        @context_link = ContextLink::PositiveContextLink.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        @context_link_attrs = @context_link.attributes
        @lu_attrs = {:node_from_id => @context_link.user_node_from.id, :node_to_id => @context_link.user_node_to.id, :user_id => @user.id}
        @gl_attrs = {:node_from_id => @context_link.question_node_from.id, :node_to_id => @context_link.question_node_to.id, :question_id => @question.id}
        Link::QuestionLink.where(@gl_attrs)[0].users_count.should == 1 
        @context_link_two = ContextLink::PositiveContextLink.create(:user=>@user_two, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
        Link::QuestionLink.where(@gl_attrs)[0].users_count.should == 2 
      end
      it 'should destroy the context_link' do
        ContextLink::PositiveContextLink.where(@context_link_attrs)[0].should_not be_nil
        @context_link.destroy
        ContextLink::PositiveContextLink.where(@context_link_attrs)[0].should be_nil
      end

      it 'should decrement the context_links count by 1' do
        expect {
          @context_link.destroy
        }.to change(ContextLink, :count).by(-1)
      end

      it 'should destroy the gl' do
        Link::QuestionLink.where(@gl_attrs)[0].should_not be_nil
        @context_link.destroy
        Link::QuestionLink.where(@gl_attrs)[0].should_not be_nil
      end

      it 'should decrement the gl count by 1' do
        expect {
          @context_link.destroy
        }.to change(Link::GlobalLink, :count).by(0)
      end

      it 'should decrement the gls context_link count by 1' do
        Link::QuestionLink.count.should == 1
        Link::QuestionLink.where(@gl_attrs)[0].users_count.should == 2
        @context_link.destroy
        Link::QuestionLink.count.should == 1
        Link::QuestionLink.where(@gl_attrs)[0].users_count.should == 1 
      end

      it 'should not destroy the lu' do
        Link::UserLink.where(@lu_attrs)[0].should_not be_nil
        @context_link.destroy
        Link::UserLink.where(@lu_attrs)[0].should be_nil
      end

      it 'should not decrement the lu count' do
        expect {
          @context_link.destroy
        }.to change(Link::UserLink, :count).by(-1)
      end
      
      it 'should update the caches' do
        node_to = Node::GlobalNode.where(:title => @gnu2.global_node.title)[0]
        gnu_to = ContextNode.where(:question_id => @question.id, :node_title_id => @gnu2.node_title_id, :user_id => @user.id)[0]
        gn_to = Node::QuestionNode.where(:question_id => @question.id, :node_title_id => @gnu2.node_title_id)[0]
        nu_to = Node::UserNode.where(:node_title_id => @gnu2.node_title_id, :user_id => @user.id)[0]
        node_to.upvotes_count.should == 2
        gn_to.upvotes_count.should == 2
        nu_to.upvotes_count.should == 1
        @context_link.destroy
        node_to = Node::GlobalNode.where(:title => @gnu2.global_node.title)[0]
        gnu_to = ContextNode.where(:question_id => @question.id, :node_title_id => @gnu2.node_title_id, :user_id => @user.id)[0]
        gn_to = Node::QuestionNode.where(:question_id => @question.id, :node_title_id => @gnu2.node_title_id)[0]
        nu_to = Node::UserNode.where(:node_title_id => @gnu2.node_title_id, :user_id => @user.id)[0]
        node_to.reload.upvotes_count.should == 1 
        gn_to.upvotes_count.should == 1
        nu_to.upvotes_count.should == 0 
      end

    end
  end
  describe 'something about node destroy through link' do
    context 'when the node was created directly' do
      pending
    end
    context 'when node created through link' do
      context 'and only the cl to be destroyed supports this creation' do
        pending
      end
      context 'and more than the cl to be destroyed support this creation' do
        pending
      end
    end
  end

end
