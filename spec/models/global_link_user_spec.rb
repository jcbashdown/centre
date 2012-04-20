require 'spec_helper'

describe GlobalLinkUser do
  describe 'create' do
    context 'when there is no existing glu' do
      before do
        @global = FactoryGirl.create(:global)
        @user = FactoryGirl.create(:user)
        @gnu1 = GlobalNodeUser.create(:title => 'title', :global => @global, :user => @user)
        @gnu2 = GlobalNodeUser.create(:title => 'test', :global => @global, :user => @user)
      end
      it 'should create a glu' do
        expect {
          GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        }.to change(GlobalLinkUser, :count).by(1)
      end
      it 'should create the glu' do
        glu = GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        glu.should be_persisted
        glu = GlobalLinkUser.where(:user_id=>@user.id, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1, :global_id=>@global.id).count .should == 1
      end
      it 'should create a gl' do
        expect {
          GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        }.to change(GlobalLink, :count).by(1)
      end
      it 'should create the gl' do
        glu = GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        glu.global_link.should be_persisted
        glu.global_link.should be_a(GlobalLink)
        glu.global_link.reload.global_link_users_count.should == 1
      end
      it 'should create an lu' do
        expect {
          GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        }.to change(LinkUser, :count).by(1)
      end
      it 'should create the lu' do
        glu = GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        glu.link_user.should be_persisted
        glu.link_user.should be_a(LinkUser)
        glu.link_user.reload.global_link_users_count.should == 1
      end
      it 'should create an l' do
        expect {
          GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        }.to change(Link, :count).by(1)
      end
      it 'should create the l' do
        glu = GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        glu.link.should be_persisted
        glu.link.should be_a(Link)
        glu.link.reload.global_link_users_count.should == 1
      end
      it 'should create the gnus and increment the votes' do
        glu = GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        glu.global_node_user_from.should be_persisted
        glu.global_node_user_from.should be_a(GlobalNodeUser)
        glu.global_node_user_from.reload.global_link_users_count.should == 1
        glu.global_node_user_from.upvotes_count.should == 0 
        glu.global_node_user_to.should be_persisted
        glu.global_node_user_to.should be_a(GlobalNodeUser)
        glu.global_node_user_to.reload.global_link_users_count.should == 1
        glu.global_node_user_to.upvotes_count.should == 1
      end
      it 'should increment the votes on the n' do
        GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        node_to = Node.where(:id => @gnu2.node.id)[0]
        node_to.upvotes_count.should == 1
        node_from = Node.where(:id => @gnu1.node.id)[0]
        node_from.should_not be_nil
        node_from.upvotes_count.should == 0 
      end
      it 'should increment the votes on the gn' do
        GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        node_to = GlobalNode.where(:node_id => @gnu2.node.id, :global_id => @global.id)[0]
        node_to.upvotes_count.should == 1
        node_from = GlobalNode.where(:node_id => @gnu1.node.id, :global_id => @global.id)[0]
        node_from.should_not be_nil
        node_from.upvotes_count.should == 0
      end
      it 'should register the vote on nu' do
        GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        node_to = NodeUser.where(:node_id => @gnu2.node.id, :user_id => @user.id)[0]
        node_to.upvotes_count.should == 1
        node_from = NodeUser.where(:node_id => @gnu1.node.id, :user_id => @user.id)[0]
        node_from.should_not be_nil
        node_from.upvotes_count.should == 0 
      end
      context 'when creating a duplicate glu' do
        before do
          GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        end
        it 'should create a glu' do
          expect {
            GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
          }.to change(GlobalLinkUser, :count).by(0)
        end
        it 'should create the glu' do
          GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
          glu = GlobalLinkUser.where(:user_id=>@user.id, :global_id => @global.id, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)[0]
          glu.should be_persisted
          glu = GlobalLinkUser.where(:user_id=>@user.id, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1, :global_id=>@global.id).count .should == 1
        end
        it 'should create a gl' do
          expect {
            GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
          }.to change(GlobalLink, :count).by(0)
        end
        it 'should create the gl' do
          GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
          glu = GlobalLinkUser.where(:user_id=>@user.id, :global_id => @global.id, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)[0]
          glu.global_link.should be_persisted
          glu.global_link.should be_a(GlobalLink)
          glu.global_link.reload.global_link_users_count.should == 1
        end
        it 'should create an lu' do
          expect {
            GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
          }.to change(LinkUser, :count).by(0)
        end
        it 'should create the lu' do
          GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
          glu = GlobalLinkUser.where(:user_id=>@user.id, :global_id => @global.id, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)[0]
          glu.link_user.should be_persisted
          glu.link_user.should be_a(LinkUser)
          glu.link_user.reload.global_link_users_count.should == 1
        end
        it 'should create an l' do
          expect {
            GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
          }.to change(Link, :count).by(0)
        end
        it 'should create the l' do
          GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
          glu = GlobalLinkUser.where(:user_id=>@user.id, :global_id => @global.id, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)[0]
          glu.link.should be_persisted
          glu.link.should be_a(Link)
          glu.link.reload.global_link_users_count.should == 1
        end
        it 'should create the gnus and increment the votes' do
          GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
          glu = GlobalLinkUser.where(:user_id=>@user.id, :global_id => @global.id, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)[0]
          glu.global_node_user_from.should be_persisted
          glu.global_node_user_from.should be_a(GlobalNodeUser)
          glu.global_node_user_from.reload.global_link_users_count.should == 1
          glu.global_node_user_from.upvotes_count.should == 0 
          glu.global_node_user_to.should be_persisted
          glu.global_node_user_to.should be_a(GlobalNodeUser)
          glu.global_node_user_to.reload.global_link_users_count.should == 1
          glu.global_node_user_to.upvotes_count.should == 1
        end
        it 'should increment the votes on the n' do
          GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
          node_to = Node.where(:id => @gnu2.node.id)[0]
          node_to.upvotes_count.should == 1
          node_from = Node.where(:id => @gnu1.node.id)[0]
          node_from.should_not be_nil
          node_from.upvotes_count.should == 0 
        end
        it 'should increment the votes on the gn' do
          GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
          node_to = GlobalNode.where(:node_id => @gnu2.node.id, :global_id => @global.id)[0]
          node_to.upvotes_count.should == 1
          node_from = GlobalNode.where(:node_id => @gnu1.node.id, :global_id => @global.id)[0]
          node_from.should_not be_nil
          node_from.upvotes_count.should == 0
        end
        it 'should register the vote on nu' do
          GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
          node_to = NodeUser.where(:node_id => @gnu2.node.id, :user_id => @user.id)[0]
          node_to.upvotes_count.should == 1
          node_from = NodeUser.where(:node_id => @gnu1.node.id, :user_id => @user.id)[0]
          node_from.should_not be_nil
          node_from.upvotes_count.should == 0 
        end
      end
    end
    context 'when creating equivalents' do
      before do
        @global = FactoryGirl.create(:global)
        @user = FactoryGirl.create(:user)
        @gnu1 = GlobalNodeUser.create(:title => 'title', :global => @global, :user => @user)
        @gnu2 = GlobalNodeUser.create(:title => 'test', :global => @global, :user => @user)
      end
      it 'should create a glu' do
        expect {
          GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 0)
        }.to change(GlobalLinkUser, :count).by(1)
      end
      it 'should create the glu' do
        glu = GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 0)
        glu.should be_persisted
        glu = GlobalLinkUser.where(:user_id=>@user.id, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 0, :global_id=>@global.id).count .should == 1
      end
      it 'should create a gl' do
        expect {
          GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 0)
        }.to change(GlobalLink, :count).by(1)
      end
      it 'should create the gl' do
        glu = GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 0)
        glu.global_link.should be_persisted
        glu.global_link.should be_a(GlobalLink)
        glu.global_link.reload.global_link_users_count.should == 1
      end
      it 'should create an lu' do
        expect {
          GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 0)
        }.to change(LinkUser, :count).by(1)
      end
      it 'should create the lu' do
        glu = GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 0)
        glu.link_user.should be_persisted
        glu.link_user.should be_a(LinkUser)
        glu.link_user.reload.global_link_users_count.should == 1
      end
      it 'should create an l' do
        expect {
          GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        }.to change(Link, :count).by(1)
      end
      it 'should create the l' do
        glu = GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 0)
        glu.link.should be_persisted
        glu.link.should be_a(Link)
        glu.link.reload.global_link_users_count.should == 1
      end
      it 'should create the gnus and increment the votes' do
        glu = GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 0)
        glu.global_node_user_from.should be_persisted
        glu.global_node_user_from.should be_a(GlobalNodeUser)
        glu.global_node_user_from.reload.global_link_users_count.should == 1
        glu.global_node_user_from.equivalents_count.should == 1 
        glu.global_node_user_to.should be_persisted
        glu.global_node_user_to.should be_a(GlobalNodeUser)
        glu.global_node_user_to.reload.global_link_users_count.should == 1
        glu.global_node_user_to.equivalents_count.should == 1
      end
      it 'should increment the votes on the n' do
        GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 0)
        node_to = Node.where(:id => @gnu2.node.id)[0]
        node_to.equivalents_count.should == 1
        node_from = Node.where(:id => @gnu1.node.id)[0]
        node_from.should_not be_nil
        node_from.equivalents_count.should == 1
      end
      it 'should increment the votes on the gn' do
        GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 0)
        node_to = GlobalNode.where(:node_id => @gnu2.node.id, :global_id => @global.id)[0]
        node_to.equivalents_count.should == 1
        node_from = GlobalNode.where(:node_id => @gnu1.node.id, :global_id => @global.id)[0]
        node_from.should_not be_nil
        node_from.equivalents_count.should == 1
      end
      it 'should register the vote on nu' do
        GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 0)
        node_to = NodeUser.where(:node_id => @gnu2.node.id, :user_id => @user.id)[0]
        node_to.equivalents_count.should == 1
        node_from = NodeUser.where(:node_id => @gnu1.node.id, :user_id => @user.id)[0]
        node_from.should_not be_nil
        node_from.equivalents_count.should == 1
      end
    end
  end

  describe 'destroy' do
    before do
      @global = FactoryGirl.create(:global)
      @user = FactoryGirl.create(:user)
      @gnu1 = GlobalNodeUser.create(:title => 'title', :global => @global, :user => @user)
      @gnu2 = GlobalNodeUser.create(:title => 'test', :global => @global, :user => @user)
    end
    context 'when there is only this glu' do
      before do
        @glu = GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        @glu_attrs = @glu.attributes
        @lu_attrs = {:link_id => @glu.link.id, :user_id => @user.id}
        @gl_attrs = {:link_id => @glu.link.id, :global_id => @global.id}
      end
      it 'should destroy the glu' do
        GlobalLinkUser.where(@glu_attrs)[0].should_not be_nil
        @glu.destroy
        GlobalLinkUser.where(@glu_attrs)[0].should be_nil
      end

      it 'should decrement the glus count by 1' do
        expect {
          @glu.destroy
        }.to change(GlobalLinkUser, :count).by(-1)
      end

      it 'should destroy the gl' do
        GlobalLink.where(@gl_attrs)[0].should_not be_nil
        @glu.destroy
        GlobalLink.where(@gl_attrs)[0].should be_nil
      end

      it 'should decrement the gl count by 1' do
        expect {
          @glu.destroy
        }.to change(GlobalLink, :count).by(-1)
      end

      it 'should destroy the lu' do
        LinkUser.where(@lu_attrs)[0].should_not be_nil
        @glu.destroy
        LinkUser.where(@lu_attrs)[0].should be_nil
      end

      it 'should decrement the lu count by 1' do
        expect {
          @glu.destroy
        }.to change(LinkUser, :count).by(-1)
      end
      
      it 'should update the caches' do
        @gnu2.node.reload.upvotes_count.should == 1
        @glu.destroy
        @gnu2.node.reload.upvotes_count.should == 0
      end
    end
    context 'when there is this glu and another for a different global' do
      before do
        @global_two = FactoryGirl.create(:global, :name => 'test global')
        @glu = GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        @glu_attrs = @glu.attributes
        @lu_attrs = {:link_id => @glu.link.id, :user_id => @user.id}
        @gl_attrs = {:link_id => @glu.link.id, :global_id => @global.id}
        LinkUser.where(@lu_attrs)[0].global_link_users_count.should == 1 
        @glu_two = GlobalLinkUser.create(:user=>@user, :global => @global_two, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        LinkUser.count.should == 1
        LinkUser.where(@lu_attrs)[0].global_link_users_count.should == 2 
      end
      it 'should destroy the glu' do
        GlobalLinkUser.where(@glu_attrs)[0].should_not be_nil
        @glu.destroy
        GlobalLinkUser.where(@glu_attrs)[0].should be_nil
      end

      it 'should decrement the glus count by 1' do
        expect {
          @glu.destroy
        }.to change(GlobalLinkUser, :count).by(-1)
      end

      it 'should destroy the gl' do
        GlobalLink.where(@gl_attrs)[0].should_not be_nil
        @glu.destroy
        GlobalLink.where(@gl_attrs)[0].should be_nil
      end

      it 'should decrement the gl count by 1' do
        expect {
          @glu.destroy
        }.to change(GlobalLink, :count).by(-1)
      end

      it 'should decrement the lus glu count by 1' do
        LinkUser.count.should == 1
        LinkUser.where(@lu_attrs)[0].global_link_users_count.should == 2
        @glu.destroy
        LinkUser.count.should == 1
        LinkUser.where(@lu_attrs)[0].global_link_users_count.should == 1 
      end

      it 'should not destroy the lu' do
        LinkUser.where(@lu_attrs)[0].should_not be_nil
        @glu.destroy
        LinkUser.where(@lu_attrs)[0].should_not be_nil
      end

      it 'should not decrement the lu count' do
        expect {
          @glu.destroy
        }.to change(LinkUser, :count).by(0)
      end
      
      it 'should update the caches' do
        node_to = Node.where(:title => @gnu2.node.title)[0]
        gnu_to = GlobalNodeUser.where(:global_id => @global.id, :node_id => @gnu2.node_id, :user_id => @user.id)[0]
        gn_to = GlobalNode.where(:global_id => @global.id, :node_id => @gnu2.node_id)[0]
        nu_to = NodeUser.where(:node_id => @gnu2.node_id, :user_id => @user.id)[0]
        node_to.upvotes_count.should == 1 
        gnu_to.upvotes_count.should == 1
        gn_to.upvotes_count.should == 1
        nu_to.upvotes_count.should == 1 
        @glu.destroy
        node_to = Node.where(:title => @gnu2.node.title)[0]
        gnu_to = GlobalNodeUser.where(:global_id => @global.id, :node_id => @gnu2.node_id, :user_id => @user.id)[0]
        gn_to = GlobalNode.where(:global_id => @global.id, :node_id => @gnu2.node_id)[0]
        nu_to = NodeUser.where(:node_id => @gnu2.node_id, :user_id => @user.id)[0]
        node_to.reload.upvotes_count.should == 1 
        gnu_to.upvotes_count.should == 0 
        gn_to.upvotes_count.should == 0
        nu_to.upvotes_count.should == 1 
      end
    end
    context 'when there is this glu and another for a different user' do
      before do
        @user_two = FactoryGirl.create(:user, :email => "test@user.com")
        @glu = GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        @glu_attrs = @glu.attributes
        @lu_attrs = {:link_id => @glu.link.id, :user_id => @user.id}
        @gl_attrs = {:link_id => @glu.link.id, :global_id => @global.id}
        GlobalLink.where(@gl_attrs)[0].global_link_users_count.should == 1 
        @glu_two = GlobalLinkUser.create(:user=>@user_two, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        GlobalLink.where(@gl_attrs)[0].global_link_users_count.should == 2 
      end
      it 'should destroy the glu' do
        GlobalLinkUser.where(@glu_attrs)[0].should_not be_nil
        @glu.destroy
        GlobalLinkUser.where(@glu_attrs)[0].should be_nil
      end

      it 'should decrement the glus count by 1' do
        expect {
          @glu.destroy
        }.to change(GlobalLinkUser, :count).by(-1)
      end

      it 'should destroy the gl' do
        GlobalLink.where(@gl_attrs)[0].should_not be_nil
        @glu.destroy
        GlobalLink.where(@gl_attrs)[0].should_not be_nil
      end

      it 'should decrement the gl count by 1' do
        expect {
          @glu.destroy
        }.to change(GlobalLink, :count).by(0)
      end

      it 'should decrement the gls glu count by 1' do
        GlobalLink.count.should == 1
        GlobalLink.where(@gl_attrs)[0].global_link_users_count.should == 2
        @glu.destroy
        GlobalLink.count.should == 1
        GlobalLink.where(@gl_attrs)[0].global_link_users_count.should == 1 
      end

      it 'should not destroy the lu' do
        LinkUser.where(@lu_attrs)[0].should_not be_nil
        @glu.destroy
        LinkUser.where(@lu_attrs)[0].should be_nil
      end

      it 'should not decrement the lu count' do
        expect {
          @glu.destroy
        }.to change(LinkUser, :count).by(-1)
      end
      
      it 'should update the caches' do
        node_to = Node.where(:title => @gnu2.node.title)[0]
        gnu_to = GlobalNodeUser.where(:global_id => @global.id, :node_id => @gnu2.node_id, :user_id => @user.id)[0]
        gn_to = GlobalNode.where(:global_id => @global.id, :node_id => @gnu2.node_id)[0]
        nu_to = NodeUser.where(:node_id => @gnu2.node_id, :user_id => @user.id)[0]
        node_to.upvotes_count.should == 2
        gnu_to.upvotes_count.should == 1
        gn_to.upvotes_count.should == 2
        nu_to.upvotes_count.should == 1
        @glu.destroy
        node_to = Node.where(:title => @gnu2.node.title)[0]
        gnu_to = GlobalNodeUser.where(:global_id => @global.id, :node_id => @gnu2.node_id, :user_id => @user.id)[0]
        gn_to = GlobalNode.where(:global_id => @global.id, :node_id => @gnu2.node_id)[0]
        nu_to = NodeUser.where(:node_id => @gnu2.node_id, :user_id => @user.id)[0]
        node_to.reload.upvotes_count.should == 1 
        gnu_to.upvotes_count.should == 0 
        gn_to.upvotes_count.should == 1
        nu_to.upvotes_count.should == 0 
      end

    end
  end

end
