require 'spec_helper'

describe Global do
  before do
    @user = FactoryGirl.create(:user)
    @global = FactoryGirl.create(:global)
  end
  describe 'set_global_links' do
    context 'when there are 4 links - 2 identical for different users, one contradicatory and one other' do
      before do
        @user_two = FactoryGirl.create(:user, :email=>'test@user.com', :password=>'123456AA')
        @user_three = FactoryGirl.create(:user, :email=>'test@user_two.com', :password=>'123456AA')
        @node_one = GlobalNodeUser.create(:global => @global, :user => @user, :title=>'a').node
        @node_two = GlobalNodeUser.create(:global => @global, :user => @user, :title=>'b').node
        @node_three = GlobalNodeUser.create(:global => @global, :user => @user, :title=>'c').node
        @gl1=GlobalLinkUser.create(:user => @user, :global => @global, :node_from=> @node_one, :value=>-1, :node_to=>@node_two).global_link
        @gl2=GlobalLinkUser.create(:user => @user_two, :global => @global, :node_from=> @node_one, :value=>1, :node_to=>@node_two).global_link
        @gl3=GlobalLinkUser.create(:user => @user_three, :global => @global, :node_from=> @node_one, :value=>1, :node_to=>@node_two).global_link
        @gl2.reload.should == @gl3
        @gl4=GlobalLinkUser.create(:user => @user_three, :global => @global, :node_from=> @node_one, :value=>1, :node_to=>@node_three).global_link
        @gl5=GlobalLinkUser.create(:user => @user_three, :global => @global, :node_from=> @node_three, :value=>1, :node_to=>@node_two).global_link
        @global_links_in_alph_up_for_node_two = [@gl2.id, @gl5.id]
        @global_links_out_alph_up_for_node_one = [@gl2.id, @gl4.id]
      end
      it 'should return the correct links to the node ordered alphabetically by default' do
        @global.global_to_node_links(@node_two)[0].id.should == @global_links_in_alph_up_for_node_two[0]
        @global.global_to_node_links(@node_two)[1].id.should == @global_links_in_alph_up_for_node_two[1]
      end
      it 'should return the correct links from the node ordered alphabetically by default' do
        @global.global_from_node_links(@node_one)[0].id.should == @global_links_out_alph_up_for_node_one[0]
        @global.global_from_node_links(@node_one)[1].id.should == @global_links_out_alph_up_for_node_one[1]
      end
    end
  end
#  describe 'set_user_links' do
#    context 'when there is a user' do
#      before do
#        @user_two = FactoryGirl.create(:user, :email=>'test@user.com', :password=>'123456AA')
#        @node_one = GlobalNodeUser.create(:global => @global, :user => @user, :title=>'aone1').node
#        @node_two = GlobalNodeUser.create(:global => @global, :user => @user, :title=>'ctwo2').node
#        @node_three = GlobalNodeUser.create(:global => @global, :user => @user, :title=>'bthree3').node
#        @link1=GlobalLinkUser.create(:user => @user, :global => @global, :node_from=> @node_one, :value=>1, :node_to=>@node_two).link
#        @link1u2=Link.new(:node_from=> @node_one, :node_to=>@node_two)
#        #node two activity is one
#        @link2=GlobalLinkUser.create(:user => @user, :global => @global, :node_from=> @node_one, :value=>1, :node_to=>@node_three).link
#        @link2u2=GlobalLinkUser.create(:user => @user_two, :global => @global, :node_from=> @node_one, :value=>1, :node_to=>@node_three).link
#        #node three activity is two
#        @link3=GlobalLinkUser.create(:user => @user, :global => @global, :node_from=> @node_two, :value=>1, :node_to=>@node_one).link
#        @link3u2=Link.new(:node_from=> @node_two, :node_to=>@node_one)
#        #node one activity is one
#        @link4=Link.new(:node_from=> @node_two, :node_to=>@node_three)
#        @link5=Link.new(:node_from=> @node_three, :node_to=>@node_one)
#        @link6=GlobalLinkUser.create(:user => @user, :global => @global, :node_from=> @node_three, :value=>-1, :node_to=>@node_two).link
#        @link6u2=GlobalLinkUser.create(:user => @user_two, :global => @global, :node_from=> @node_three, :value=>-1, :node_to=>@node_two).link
#        #node two activity is three
#        #for user = @user
#        @user_links_out_alph_up_for_node_one = [@link2.id,
#                                                @link1.id]
#        @user_links_out_alph_down_for_node_one = [@link1.id,
#                                                  @link2.id]
#        #all votes count for node count
#        @user_links_out_active_for_node_one = [@link1.id,
#                                               @link2.id]
#        @user_links_out_inactive_for_node_one = [@link2.id,
#                                                 @link1.id]
#        @user_links_out_alph_up_for_node_two = [@link3.id,
#                                                @link4.id]
#        @user_links_out_alph_down_for_node_two = [@link4.id,
#                                                  @link3]
#        #all votes count for node count
#        @user_links_out_active_for_node_two = [@link4.id,
#                                               @link3.id]
#        @user_links_out_inactive_for_node_two = [@link3.id,
#                                                 @link4.id]
#        #for user = @user_two
#        @user2_links_out_alph_up_for_node_one = [@link2.id,
#                                                 @link1u2.id]
#        @user2_links_out_alph_down_for_node_one = [@link1u2.id,
#                                                   @link2.id]
#        #all votes count for node count
#        @user2_links_out_active_for_node_one = [@link1u2.id,
#                                                @link2.id]
#        @user2_links_out_inactive_for_node_one = [@link2.id,
#                                                  @link1u2.id]
#        @user2_links_out_alph_up_for_node_two = [@link3u2.id,
#                                                 @link4.id]
#        @user2_links_out_alph_down_for_node_two = [@link4.id,
#                                                   @link3u2.id]
#        #all votes count for node count
#        @user2_links_out_active_for_node_two = [@link4.id,
#                                                @link3u2.id]
#        @user2_links_out_inactive_for_node_two = [@link3u2.id,
#                                                  @link4.id]
#      end
#      #set user links can happen here but method it calls - specs should be moved to user
#      it 'should return the user links for @user from @node_one and construct those not present in alphabet order as default' do
#        @user.user_from_node_links(@node_one).each do |node|
#           @user_links_out_alph_up_for_node_one.should include node.id
#        end
#      end
#      it 'should return the user links for @user_two from @node_one and construct those not present in alphabet order as default' do
#        @user_two.user_from_node_links(@node_one).each do |node|
#          @user2_links_out_alph_up_for_node_one.should include node.id
#        end
#      end
#      it 'should return the user links for @user from @node_two and construct those not present in alphabet order as default' do
#        @user.user_from_node_links(@node_two).each do |node|
#          @user_links_out_alph_up_for_node_two.should include node.id
#        end
#      end
#      it 'should return the user links for @user_two from @node_two and construct those not present in alphabet order as default' do
#        @user_two.user_from_node_links(@node_two).each do |node|
#          @user2_links_out_alph_up_for_node_two.should include node.id
#        end
#      end
#    end
#    context 'links in for node' do
#      before do
#        @user_two = FactoryGirl.create(:user, :email=>'test@user.com', :password=>'123456AA')
#        @node_one = GlobalNodeUser.create(:global => @global, :user => @user, :title=>'aone1').node
#        @node_two = GlobalNodeUser.create(:global => @global, :user => @user, :title=>'ctwo2').node
#        @node_three = GlobalNodeUser.create(:global => @global, :user => @user, :title=>'bthree3').node
#        @link1=GlobalLinkUser.create(:user => @user, :global => @global, :node_from=> @node_one, :value=>1, :node_to=>@node_two).link
#        @link1u2=Link.new(:node_from=> @node_one, :node_to=>@node_two)
#        #node two activity is one
#        @link2=GlobalLinkUser.create(:user => @user, :global => @global, :node_from=> @node_one, :value=>1, :node_to=>@node_three).link
#        @link2u2=GlobalLinkUser.create(:user => @user_two, :global => @global, :node_from=> @node_one, :value=>1, :node_to=>@node_three).link
#        #node three activity is two
#        @link3=GlobalLinkUser.create(:user => @user, :global => @global, :node_from=> @node_two, :value=>1, :node_to=>@node_one).link
#        @link3u2=Link.new(:node_from=> @node_two, :node_to=>@node_one)
#        #node one activity is one
#        @link4=Link.new(:node_from=> @node_two, :node_to=>@node_three)
#        @link5=Link.new(:node_from=> @node_three, :node_to=>@node_one)
#        @link6=GlobalLinkUser.create(:user => @user, :global => @global, :node_from=> @node_three, :value=>-1, :node_to=>@node_two).link
#        @link6u2=GlobalLinkUser.create(:user => @user_two, :global => @global, :node_from=> @node_three, :value=>-1, :node_to=>@node_two).link
#        #node two activity is three
#        #for user = @user
#        @user_links_in_alph_up_for_node_one = [@link5.id,
#                                                @link3.id]
#        @user_links_in_alph_down_for_node_one = [@link3.id,
#                                                  @link5.id]
#        @user_links_in_alph_up_for_node_two = [@link1.id,
#                                                @link6.id]
#        @user_links_in_alph_down_for_node_two = [@link6.id,
#                                                  @link1.id]
#        @user2_links_in_alph_up_for_node_one = [@link5.id,
#                                                @link3u2.id]
#        @user2_links_in_alph_down_for_node_one = [@link5.id,
#                                                  @link3u2.id]
#        @user2_links_in_alph_up_for_node_two = [@link1u2.id,
#                                                @link6.id]
#        @user2_links_in_alph_down_for_node_two = [@link6u2.id,
#                                                  @link1.id]
#      end
#      it 'should return the user links for @user from @node_one and construct those not present in alphabet order as default' do
#        @user.user_to_node_links(@node_one).each do |node|
#          @user_links_in_alph_up_for_node_one.should include node.id
#        end
#      end
#      it 'should return the user links for @user_two from @node_one and construct those not present in alphabet order as default' do
#        @user_two.user_to_node_links(@node_one).each do |node|
#          @user2_links_in_alph_up_for_node_one.should include node.id
#        end
#      end
#      it 'should return the user links for @user from @node_two and construct those not present in alphabet order as default' do
#        @user.user_to_node_links(@node_two).each do |node|
#          @user_links_in_alph_up_for_node_two.should include node.id
#        end
#      end
#      it 'should return the user links for @user_two from @node_two and construct those not present in alphabet order as default' do
#        @user_two.user_to_node_links(@node_two).each do |node|
#          @user2_links_in_alph_up_for_node_two.should include node.id
#        end
#      end
#    end
#  end
end
