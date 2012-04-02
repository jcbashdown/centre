require 'spec_helper'

describe GlobalLinkUser do
  describe 'create' do
    context 'when there is no existing glu or gnus' do
      before do
        @global = Factory(:global)
        @user = Factory(:user)
        @node_one = Factory(:node)
        @node_two = Factory(:node, :title=>'title')
        @link = Link.create(:node_from_id => @node_one.id, :value => 1, :node_to_id => @node_two.id)
        #GlobalLinkUser.create(:global => @question, :link_id => @link.id, :user => @user, :node_from_id => @link.node_from_id, :node_to_id => @link.node_to_id)
      end
      it 'should create 2 glus (for this and all)' do
        expect {
          GlobalLinkUser.create(:user=>@user, :link=>@link, :global => @global, :node_from_id => @node_one.id, :node_to_id => @node_two.id)
        }.to change(GlobalLinkUser, :count).by(2)
      end
      it 'should create the glu for this and all' do
        glu = GlobalLinkUser.create(:user=>@user, :link=>@link, :global => @global, :node_from_id => @node_one.id, :node_to_id => @node_two.id)
        glu.should be_persisted
        glu_all = GlobalLinkUser.where(:user_id=>@user.id, :link_id=>@link.id, :global_id=>Global.find_by_name('All').id)[0].should be_a(GlobalLinkUser)
      end
      it 'should create 2 gls (for this and all)' do
        expect {
          GlobalLinkUser.create(:user=>@user, :link=>@link, :global =>@global, :node_from_id => @node_one.id, :node_to_id => @node_two.id)
        }.to change(GlobalLink, :count).by(2)
      end
      it 'should create the gl for this and all' do
        glu = GlobalLinkUser.create(:user=>@user, :link=>@link, :global => @global, :node_from_id => @node_one.id, :node_to_id => @node_two.id)
        glu.global_link.should be_persisted
        glu.global_link.should be_a(GlobalLink)
        glu.global_link.global_link_users_count.should == 1
        glu_all = GlobalLinkUser.where(:user_id=>@user.id, :link_id=>@link.id, :global_id=>Global.find_by_name('All').id)[0].should be_a(GlobalLinkUser)
        glu_all.global_link.should be_a(GlobalLink)
        glu_all.global_link.global_link_users_count.should == 1
      end
      it 'should create 2 lus (for this and all)' do
        expect {
          GlobalLinkUser.create(:user=>@user, :link=>@link, :global => @global, :node_from_id => @node_one.id, :node_to_id => @node_two.id)
        }.to change(LinkUser, :count).by(1)
      end
      it 'should create the lu' do
        glu = GlobalLinkUser.create(:user=>@user, :link=>@link, :global => @global, :node_from_id => @node_one.id, :node_to_id => @node_two.id)
        glu.link_user.should be_persisted
        glu.link_user.should be_a(LinkUser)
      end
      it 'should create the gnus and increment the votes' do
        glu = GlobalLinkUser.create(:user=>@user, :link=>@link, :global => @global, :node_from_id => @node_one.id, :node_to_id => @node_two.id)
        glu.global_node_user_from.should be_persisted
        glu.global_node_user_from.should be_a(GlobalNodeUser)
        glu.global_node_user_from.global_link_users_count.should == 1
        glu.global_node_user_to.should be_persisted
        glu.global_node_user_to.should be_a(GlobalNodeUser)
        glu.global_node_user_to.global_link_users_count.should == 1
        glu.global_node_user_to.upvotes_count.should == 1
        glu_all = GlobalLinkUser.where(:user_id=>@user.id, :link_id=>@link.id, :global_id => Global.find_by_name('All').id, :node_from_id => @node_one.id, :node_to_id => @node_two.id)
        glu_all.global_node_user_from.should be_persisted
        glu_all.global_node_user_from.should be_a(GlobalNodeUser)
        glu_all.global_node_user_from.global_link_users_count.should == 1
        glu_all.global_node_user_to.should be_persisted
        glu_all.global_node_user_to.should be_a(GlobalNodeUser)
        glu_all.global_node_user_to.global_link_users_count.should == 1
        glu_all.global_node_user_to.upvotes_count.should == 1
      end
      it 'should increment the votes on the gn' do
        GlobalLinkUser.create(:user=>@user, :link=>@link, :global => @global, :node_from_id => @node_one.id, :node_to_id => @node_two.id)
        GlobalNode.where(:node_id => @node_two.id, :global_id => @global.id)[0].upvotes_count.should == 1
        GlobalNode.where(:node_id => @node_two.id, :global_id => Global.find_by_name('All').id)[0].upvotes_count.should == 1
      end
      it 'should register the vote on nu' do
        GlobalLinkUser.create(:user=>@user, :link=>@link, :global => @global, :node_from_id => @node_one.id, :node_to_id => @node_two.id)
        NodeUser.where(:node_id => @node_two.id, :user_id => @user.id)[0].upvotes_count.should == 1
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
