require 'spec_helper'

describe GlobalLinkUser do
  describe 'create' do
    context 'when there is no existing glu' do
      before do
        @global = Factory(:global)
        @user = Factory(:user)
        @gnu1 = GlobalNodeUser.create(:title => 'title', :global => @global, :user => @user)
        @gnu2 = GlobalNodeUser.create(:title => 'test', :global => @global, :user => @user)
      end
      it 'should create 2 glus (for this and all)' do
        expect {
          GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        }.to change(GlobalLinkUser, :count).by(1)
      end
      it 'should create the glu for this' do
        glu = GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        glu.should be_persisted
        glu = GlobalLinkUser.where(:user_id=>@user.id, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1, :global_id=>@global.id).count .should == 1
      end
      it 'should create 2 gls (for this and all)' do
        expect {
          GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        }.to change(GlobalLink, :count).by(1)
      end
      it 'should create the gl for this and all' do
        glu = GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        glu.global_link.should be_persisted
        glu.global_link.should be_a(GlobalLink)
        glu.global_link.reload.global_link_users_count.should == 1
      end
      it 'should create 1 lu' do
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
        glu.global_node_user_to.should be_persisted
        glu.global_node_user_to.should be_a(GlobalNodeUser)
        glu.global_node_user_to.reload.global_link_users_count.should == 1
        glu.global_node_user_to.upvotes_count.should == 1
      end
      it 'should increment the votes on the gn' do
        GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        Node.where(:id => @gnu2.node.id)[0].upvotes_count.should == 1
        Node.where(:id => @gnu1.node.id)[0].should_not be_nil
      end
      it 'should increment the votes on the gn' do
        GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        GlobalNode.where(:node_id => @gnu2.node.id, :global_id => @global.id)[0].upvotes_count.should == 1
        GlobalNode.where(:node_id => @gnu1.node.id, :global_id => @global.id)[0].should_not be_nil
      end
      it 'should register the vote on nu' do
        GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        NodeUser.where(:node_id => @gnu2.node.id, :user_id => @user.id)[0].upvotes_count.should == 1
        NodeUser.where(:node_id => @gnu1.node.id, :user_id => @user.id)[0].should_not be_nil
      end
    end
  end

  describe 'update' do

  end

  describe 'destroy' do
    #Do this first as it will need to be used when updating association
    #
    context 'when there is only this glu and all and associated gnus' do
      context 'from the non all glu' do
        it 'should destroy the glu and all glu' do
  
        end
  
        it 'should decrement the glus count by two' do
  
        end
  
        it 'should destroy the gl and all gl' do
  
        end

        it 'should decrement the gl count by two' do
  
        end
  
        it 'should destroy the lu' do

        end

        it 'should decrement the lu count by 1' do
  
        end
  
        it 'should destroy all 4 gnus (unless they created it? or we shouldnt be creating gnus unless through links?)' do

        end
      end
    end
  end

end
