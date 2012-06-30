require 'spec_helper'

describe Question do
  before do
    @user = FactoryGirl.create(:user)
    @global = FactoryGirl.create(:global)
  end
  describe 'set_global_links' do
    it 'should get all nodes when global is all and get link values from highest count link for combo (base link count)' do
      pending
    end
    context 'when there are 4 links - 2 identical for different users, one contradicatory and one other' do
      before do
        @user_two = FactoryGirl.create(:user, :email=>'test@user.com', :password=>'123456AA')
        @user_three = FactoryGirl.create(:user, :email=>'test@user_two.com', :password=>'123456AA')
        @node_one = GlobalNodeUser.create(:global => @global, :user => @user, :title=>'a').node
        @node_two = GlobalNodeUser.create(:global => @global, :user => @user, :title=>'b').node
        @node_three = GlobalNodeUser.create(:global => @global, :user => @user, :title=>'c').node
        @gl1=GlobalLinkUser.create(:user => @user, :global => @global, :node_from=> @node_one, :value=>-1, :node_to=>@node_two).link
        @gl2=GlobalLinkUser.create(:user => @user_two, :global => @global, :node_from=> @node_one, :value=>1, :node_to=>@node_two).link
        @gl3=GlobalLinkUser.create(:user => @user_three, :global => @global, :node_from=> @node_one, :value=>1, :node_to=>@node_two).link
        @gl2.reload.should == @gl3
        @gl4=GlobalLinkUser.create(:user => @user_three, :global => @global, :node_from=> @node_one, :value=>1, :node_to=>@node_three).link
        @gl5=GlobalLinkUser.create(:user => @user_three, :global => @global, :node_from=> @node_three, :value=>1, :node_to=>@node_two).link
        @global_links_in_alph_up_for_node_two = [@gl2.id, @gl5.id]
        @global_links_out_alph_up_for_node_one = [@gl2.id, @gl4.id]
      end
      it 'should test order for to' do
        pending
      end
      it 'should return the correct links to the node ordered alphabetically by default' do
        @global.global_to_node_links(@node_two)[0].id.should == @global_links_in_alph_up_for_node_two[0]
        @global.global_to_node_links(@node_two)[1].id.should == @global_links_in_alph_up_for_node_two[1]
      end
      it 'should test order for from' do
        pending
      end
      it 'should return the correct links from the node ordered alphabetically by default' do
        @global.global_from_node_links(@node_one)[0].id.should == @global_links_out_alph_up_for_node_one[0]
        @global.global_from_node_links(@node_one)[1].id.should == @global_links_out_alph_up_for_node_one[1]
      end
    end
  end
end
