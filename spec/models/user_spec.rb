require 'spec_helper'

describe User do
  before do
    @user = FactoryGirl.create(:user)
    @global = FactoryGirl.create(:global)
  end

  describe 'set_user_links' do
    it 'should get all nodes when global is all and get link values from user from' do
      pending
    end
    it 'should get all nodes when global is all and get link values from user to' do
      pending
    end
    context 'when there is a user' do
      before do
        @user_two = FactoryGirl.create(:user, :email=>'test@user.com', :password=>'123456AA')
        @gnu_one = GlobalNodeUser.create(:global => @global, :user => @user, :title=>'aone1')
        @node_one = @gnu_one.node
        @global_node_one = @gnu_one.global_node
        @gnu_two = GlobalNodeUser.create(:global => @global, :user => @user, :title=>'ctwo2')
        @node_two = @gnu_two.node
        @global_node_two = @gnu_two.global_node
        @gnu_three = GlobalNodeUser.create(:global => @global, :user => @user, :title=>'bthree3')
        @node_three = @gnu_three.node
        @global_node_three = @gnu_three.global_node
        @link1=GlobalLinkUser.create(:user => @user, :global => @global, :node_from=> @node_one, :value=>1, :node_to=>@node_two).link
        @link1u2=Link.new(:node_from=> @node_one, :node_to=>@node_two)
        #node two activity is one
        @link2=GlobalLinkUser.create(:user => @user, :global => @global, :node_from=> @node_one, :value=>1, :node_to=>@node_three).link
        @link2u2=GlobalLinkUser.create(:user => @user_two, :global => @global, :node_from=> @node_one, :value=>1, :node_to=>@node_three).link
        #node three activity is two
        @link3=GlobalLinkUser.create(:user => @user, :global => @global, :node_from=> @node_two, :value=>1, :node_to=>@node_one).link
        @link3u2=Link.new(:node_from=> @node_two, :node_to=>@node_one)
        #node one activity is one
        @link4=Link.new(:node_from=> @node_two, :node_to=>@node_three)
        @link5=Link.new(:node_from=> @node_three, :node_to=>@node_one)
        @link6=GlobalLinkUser.create(:user => @user, :global => @global, :node_from=> @node_three, :value=>-1, :node_to=>@node_two).link
        @link6u2=GlobalLinkUser.create(:user => @user_two, :global => @global, :node_from=> @node_three, :value=>-1, :node_to=>@node_two).link
        #node two activity is three
        #for user = @user
        @user_links_out_alph_up_for_node_one = [@link2.id,
                                                @link1.id]
        @user_links_out_alph_down_for_node_one = [@link1.id,
                                                  @link2.id]
        #all votes count for node count
        @user_links_out_active_for_node_one = [@link1.id,
                                               @link2.id]
        @user_links_out_inactive_for_node_one = [@link2.id,
                                                 @link1.id]
        @user_links_out_alph_up_for_node_two = [@link3.id,
                                                @link4.id]
        @user_links_out_alph_down_for_node_two = [@link4.id,
                                                  @link3]
        #all votes count for node count
        @user_links_out_active_for_node_two = [@link4.id,
                                               @link3.id]
        @user_links_out_inactive_for_node_two = [@link3.id,
                                                 @link4.id]
        #for user = @user_two
        @user2_links_out_alph_up_for_node_one = [@link2u2.id,
                                                 @link1u2.id]
        @user2_links_out_alph_down_for_node_one = [@link1u2.id,
                                                   @link2.id]
        #all votes count for node count
        @user2_links_out_active_for_node_one = [@link1u2.id,
                                                @link2.id]
        @user2_links_out_inactive_for_node_one = [@link2.id,
                                                  @link1u2.id]
        @user2_links_out_alph_up_for_node_two = [@link3u2.id,
                                                 @link4.id]
        @user2_links_out_alph_down_for_node_two = [@link4.id,
                                                   @link3u2.id]
        #all votes count for node count
        @user2_links_out_active_for_node_two = [@link4.id,
                                                @link3u2.id]
        @user2_links_out_inactive_for_node_two = [@link3u2.id,
                                                  @link4.id]
      end
      #set user links can happen here but method it calls - specs should be moved to user
      it 'should test order for from' do
        pending
      end
      it 'should return the user links for @user from @node_one and construct those not present in alphabet order as default' do
        @user.user_from_node_links(@node_one, @global)[0].id.should == @user_links_out_alph_up_for_node_one[0]
        @user.user_from_node_links(@node_one, @global)[1].id.should == @user_links_out_alph_up_for_node_one[1]
      end
      it 'should return the user links for @user_two from @node_one and construct those not present in alphabet order as default' do
        @user_two.user_from_node_links(@node_one, @global)[0].id.should == @user2_links_out_alph_up_for_node_one[0]
        @user_two.user_from_node_links(@node_one, @global)[1].id.should == @user2_links_out_alph_up_for_node_one[1]
      end
      it 'should return the user links for @user from @node_two and construct those not present in alphabet order as default' do
        @user.user_from_node_links(@node_two, @global)[0].id.should == @user_links_out_alph_up_for_node_two[0]
        @user.user_from_node_links(@node_two, @global)[1].id.should == @user_links_out_alph_up_for_node_two[1]
      end
      it 'should return the user links for @user_two from @node_two and construct those not present in alphabet order as default' do
        @user_two.user_from_node_links(@node_two, @global)[0].id.should == @user2_links_out_alph_up_for_node_two[0]
        @user_two.user_from_node_links(@node_two, @global)[0].id.should == @user2_links_out_alph_up_for_node_two[1]
      end
    end
    context 'links in for node' do
      before do
        @user_two = FactoryGirl.create(:user, :email=>'test@user.com', :password=>'123456AA')
        @gnu_one = GlobalNodeUser.create(:global => @global, :user => @user, :title=>'aone1')
        @node_one = @gnu_one.node
        @global_node_one = @gnu_one.global_node
        @gnu_two = GlobalNodeUser.create(:global => @global, :user => @user, :title=>'ctwo2')
        @node_two = @gnu_two.node
        @global_node_two = @gnu_two.global_node
        @gnu_three = GlobalNodeUser.create(:global => @global, :user => @user, :title=>'bthree3')
        @node_three = @gnu_three.node
        @global_node_three = @gnu_three.global_node
        @link1=GlobalLinkUser.create(:user => @user, :global => @global, :node_from=> @node_one, :value=>1, :node_to=>@node_two).link
        @link1u2=Link.new(:node_from=> @node_one, :node_to=>@node_two)
        #node two activity is one
        @link2=GlobalLinkUser.create(:user => @user, :global => @global, :node_from=> @node_one, :value=>1, :node_to=>@node_three).link
        @link2u2=GlobalLinkUser.create(:user => @user_two, :global => @global, :node_from=> @node_one, :value=>1, :node_to=>@node_three).link
        #node three activity is two
        @link3=GlobalLinkUser.create(:user => @user, :global => @global, :node_from=> @node_two, :value=>1, :node_to=>@node_one).link
        @link3u2=Link.new(:node_from=> @node_two, :node_to=>@node_one)
        #node one activity is one
        @link4=Link.new(:node_from=> @node_two, :node_to=>@node_three)
        @link5=Link.new(:node_from=> @node_three, :node_to=>@node_one)
        @link6=GlobalLinkUser.create(:user => @user, :global => @global, :node_from=> @node_three, :value=>-1, :node_to=>@node_two).link
        @link6u2=GlobalLinkUser.create(:user => @user_two, :global => @global, :node_from=> @node_three, :value=>-1, :node_to=>@node_two).link
        #node two activity is three
        #for user = @user
        @user_links_in_alph_up_for_node_one = [@link5.id,
                                                @link3.id]
        @user_links_in_alph_down_for_node_one = [@link3.id,
                                                  @link5.id]
        @user_links_in_alph_up_for_node_two = [@link1.id,
                                                @link6.id]
        @user_links_in_alph_down_for_node_two = [@link6.id,
                                                  @link1.id]
        @user2_links_in_alph_up_for_node_one = [@link5.id,
                                                @link3u2.id]
        @user2_links_in_alph_down_for_node_one = [@link5.id,
                                                  @link3u2.id]
        @user2_links_in_alph_up_for_node_two = [@link1u2.id,
                                                @link6u2.id]
        @user2_links_in_alph_down_for_node_two = [@link6u2.id,
                                                  @link1.id]
      end
      it 'should test order for to' do
        pending
      end
      it 'should return the user links for @user from @node_one and construct those not present in alphabet order as default' do
        @user.user_to_node_links(@node_one, @global)[0].id.should == @user_links_in_alph_up_for_node_one[0]
        @user.user_to_node_links(@node_one, @global)[1].id.should == @user_links_in_alph_up_for_node_one[1]
      end
      it 'should return the user links for @user_two from @node_one and construct those not present in alphabet order as default' do
        @user_two.user_to_node_links(@node_one, @global)[0].id.should == @user2_links_in_alph_up_for_node_one[0]
        @user_two.user_to_node_links(@node_one, @global)[1].id.should == @user2_links_in_alph_up_for_node_one[1]
      end
      it 'should return the user links for @user from @node_two and construct those not present in alphabet order as default' do
        @user.user_to_node_links(@node_two, @global)[0].id.should == @user_links_in_alph_up_for_node_two[0]
        @user.user_to_node_links(@node_two, @global)[1].id.should == @user_links_in_alph_up_for_node_two[1]
      end
      it 'should return the user links for @user_two from @node_two and construct those not present in alphabet order as default' do
        @user_two.user_to_node_links(@node_two, @global)[0].id.should == @user2_links_in_alph_up_for_node_two[0]
        @user_two.user_to_node_links(@node_two, @global)[1].id.should == @user2_links_in_alph_up_for_node_two[1]
      end
    end
  end
  
  before(:each) do
    @attr = { 
      :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end
  
  it "should create a new instance given a valid attribute" do
    User.create!(@attr)
  end
  
  it "should require an email address" do
    no_email_user = User.new(@attr.merge(:email => ""))
    no_email_user.should_not be_valid
  end
  
  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
      valid_email_user = User.new(@attr.merge(:email => address))
      valid_email_user.should be_valid
    end
  end
  
  it "should reject invalid email addresses" do
    addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
    addresses.each do |address|
      invalid_email_user = User.new(@attr.merge(:email => address))
      invalid_email_user.should_not be_valid
    end
  end
  
  it "should reject duplicate email addresses" do
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end
  
  describe "passwords" do

    before(:each) do
      @user = User.new(@attr)
    end

    it "should have a password attribute" do
      @user.should respond_to(:password)
    end

    it "should have a password confirmation attribute" do
      @user.should respond_to(:password_confirmation)
    end
  end
  
  describe "password validations" do

    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
        should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
        should_not be_valid
    end
    
    it "should reject short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end
    
  end
  
  describe "password encryption" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "should have an encrypted password attribute" do
      @user.should respond_to(:encrypted_password)
    end

    it "should set the encrypted password attribute" do
      @user.encrypted_password.should_not be_blank
    end

  end
  
end
