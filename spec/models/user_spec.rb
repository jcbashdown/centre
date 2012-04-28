require 'spec_helper'

describe User do
  describe 'set_user_links' do
    context 'when there is a user' do
      before do
        @user_two = FactoryGirl.create(:user, :email=>'test@user.com', :password=>'123456AA')
        @node_one = FactoryGirl.create(:node, :title=>'aone1')
        @node_two = FactoryGirl.create(:node, :title=>'ctwo2')
        @node_three = FactoryGirl.create(:node, :title=>'bthree3')
        @link1=Link.create(:node_from=> @node_one, :value=>1, :node_to=>@node_two)
        @link1u2=Link.new(:node_from=> @node_one, :node_to=>@node_two)
        @link1.users << @user
        #node two activity is one
        @link2=Link.create(:node_from=> @node_one, :value=>1, :node_to=>@node_three)
        @link2.users << @user
        @link2.users << @user_two 
        #node three activity is two
        @link3=Link.create(:node_from=> @node_two, :value=>1, :node_to=>@node_one)
        @link3u2=Link.new(:node_from=> @node_two, :node_to=>@node_one)
        @link3.users << @user
        #node one activity is one
        @link4=Link.new(:node_from=> @node_two, :node_to=>@node_three)
        @link5=Link.new(:node_from=> @node_three, :node_to=>@node_one)
        @link6=Link.create(:node_from=> @node_three, :value=>-1, :node_to=>@node_two)
        @link6.users << @user
        @link6.users << @user_two 
        #node two activity is three
        #for user = @user
        @user_links_out_alph_up_for_node_one = [@link2,
                                                @link1]
        @user_links_out_alph_down_for_node_one = [@link1,
                                                  @link2]
        #all votes count for node count
        @user_links_out_active_for_node_one = [@link1,
                                               @link2]
        @user_links_out_inactive_for_node_one = [@link2,
                                                 @link1]
        @user_links_out_alph_up_for_node_two = [@link3,
                                                @link4]
        @user_links_out_alph_down_for_node_two = [@link4,
                                                  @link3]
        #all votes count for node count
        @user_links_out_active_for_node_two = [@link4,
                                               @link3]
        @user_links_out_inactive_for_node_two = [@link3,
                                                 @link4]
        #for user = @user_two
        @user2_links_out_alph_up_for_node_one = [@link2,
                                                 @link1u2]
        @user2_links_out_alph_down_for_node_one = [@link1u2,
                                                   @link2]
        #all votes count for node count
        @user2_links_out_active_for_node_one = [@link1u2,
                                                @link2]
        @user2_links_out_inactive_for_node_one = [@link2,
                                                  @link1u2]
        @user2_links_out_alph_up_for_node_two = [@link3u2,
                                                 @link4]
        @user2_links_out_alph_down_for_node_two = [@link4,
                                                   @link3u2]
        #all votes count for node count
        @user2_links_out_active_for_node_two = [@link4,
                                                @link3u2]
        @user2_links_out_inactive_for_node_two = [@link3u2,
                                                  @link4]
      end
      #set user links can happen here but method it calls - specs should be moved to user
      it 'should return the user links for @user from @node_one and construct those not present in alphabet order as default' do
        @user.user_from_node_links(@node_one).inspect.should == @user_links_out_alph_up_for_node_one.inspect
      end
      it 'should return the user links for @user_two from @node_one and construct those not present in alphabet order as default' do
        @user_two.user_from_node_links(@node_one).inspect.should == @user2_links_out_alph_up_for_node_one.inspect
      end
      it 'should return the user links for @user from @node_two and construct those not present in alphabet order as default' do
        @user.user_from_node_links(@node_two).inspect.should == @user_links_out_alph_up_for_node_two.inspect
      end
      it 'should return the user links for @user_two from @node_two and construct those not present in alphabet order as default' do
        @user_two.user_from_node_links(@node_two).inspect.should == @user2_links_out_alph_up_for_node_two.inspect
      end
    end
    context 'links in for node' do
      before do
        @user_two = FactoryGirl.create(:user, :email=>'test@user.com', :password=>'123456AA')
        @node_one = FactoryGirl.create(:node, :title=>'aone1')
        @node_two = FactoryGirl.create(:node, :title=>'ctwo2')
        @node_three = FactoryGirl.create(:node, :title=>'bthree3')
        @link1=Link.create(:node_from=> @node_one, :value=>1, :node_to=>@node_two)
        @link1u2=Link.new(:node_from=> @node_one, :node_to=>@node_two)
        @link1.users << @user
        #node two activity is one
        @link2=Link.create(:node_from=> @node_one, :value=>1, :node_to=>@node_three)
        @link2.users << @user
        @link2.users << @user_two 
        #node three activity is two
        @link3=Link.create(:node_from=> @node_two, :value=>1, :node_to=>@node_one)
        @link3u2=Link.new(:node_from=> @node_two, :node_to=>@node_one)
        @link3.users << @user
        #node one activity is one
        @link4=Link.new(:node_from=> @node_two, :node_to=>@node_three)
        @link5=Link.new(:node_from=> @node_three, :node_to=>@node_one)
        @link6=Link.create(:node_from=> @node_three, :value=>-1, :node_to=>@node_two)
        @link6.users << @user
        @link6.users << @user_two 
        #node two activity is three
        #for user = @user
        @user_links_in_alph_up_for_node_one = [@link5,
                                                @link3]
        @user_links_in_alph_down_for_node_one = [@link3,
                                                  @link5]
        @user_links_in_alph_up_for_node_two = [@link1,
                                                @link6]
        @user_links_in_alph_down_for_node_two = [@link6,
                                                  @link1]
        @user2_links_in_alph_up_for_node_one = [@link5,
                                                @link3u2]
        @user2_links_in_alph_down_for_node_one = [@link5,
                                                  @link3u2]
        @user2_links_in_alph_up_for_node_two = [@link1u2,
                                                @link6]
        @user2_links_in_alph_down_for_node_two = [@link6u2,
                                                  @link1]
      end
      it 'should return the user links for @user from @node_one and construct those not present in alphabet order as default' do
        @user.user_to_node_links(@node_one).inspect.should == @user_links_in_alph_up_for_node_one.inspect
      end
      it 'should return the user links for @user_two from @node_one and construct those not present in alphabet order as default' do
        @user_two.user_to_node_links(@node_one).inspect.should == @user2_links_in_alph_up_for_node_one.inspect
      end
      it 'should return the user links for @user from @node_two and construct those not present in alphabet order as default' do
        @user.user_to_node_links(@node_two).inspect.should == @user_links_in_alph_up_for_node_two.inspect
      end
      it 'should return the user links for @user_two from @node_two and construct those not present in alphabet order as default' do
        @user_two.user_to_node_links(@node_two).inspect.should == @user2_links_in_alph_up_for_node_two.inspect
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
