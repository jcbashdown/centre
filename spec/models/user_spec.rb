require 'spec_helper'

describe User do
  
  before(:each) do
    @attr = { 
      :name => "Example User",
      :email => "user@example.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end
  
  describe 'create association' do
    before do
      @user = Factory(:user)
    end
    context 'when the link already exists' do
      before do
        @node_one = Factory(:node)
        @node_two = Factory(:node, :title=>'title')
        @link_one = Link.create(:node_from=>@node_one,:value=>1,:node_to=>@node_two)
        @link_one.reload
        @link_one_params = {"node_from_id"=>@node_one.id.to_s,"value"=>"1","node_to_id"=>@node_two.id.to_s}
      end
      context 'when successful' do
        it 'should associate the user' do
          new_link = @user.create_association(@link_one_params)
          @link_one.users.should include(@user)
        end
        it 'should save the newly associated link to update caches' do
          @link_one.should_receive(:save!)
          Link.stub(:where).and_return [@link_one]
          @user.create_association(@link_one_params)
        end
        it 'should return the newly associated link' do
          new_link = @user.create_association(@link_one_params)
          new_link.should == @link_one
        end
      end
    end
    context 'when the link does not exist' do
      before do
        @node_one = Factory(:node)
        @node_two = Factory(:node, :title=>'title')
        @link_one_params = {"node_from_id"=>@node_one.id,"value"=>1,"node_to_id"=>@node_two.id}
      end
      context 'when successful' do
        it 'should create the link' do
          Link.where(@link_one_params).should be_empty
          @user.create_association(@link_one_params)
          Link.where(@link_one_params)[0].should_not be_nil
        end
        it 'should associate the user' do
          new_link = @user.create_association(@link_one_params)
          new_link.users.should include(@user)
        end
        it 'should return the newly associated link' do
          new_link = @user.create_association(@link_one_params)
          new_link.should be_a(Link) 
        end
      end
    end
  end
 
  describe 'update_association' do
    before do
      @user = Factory(:user)
    end
    context 'when the user is already associated with the first link' do
      before do
        @node_one = Factory(:node)
        @node_two = Factory(:node, :title=>'title')
        @link_one = Link.create(:node_from=>@node_one,:value=>1,:node_to=>@node_two)
        @link_one.users << @user
        #TODO - again, shouldn't have to do this save here
        @link_one.save!
        @link_one.reload
        @node_two.reload
        @node_two.upvotes_count.should == 1
        @link_two_params = {"node_from_id"=>@node_one.id,"value"=>-1,"node_to_id"=>@node_two.id}
      end
      context 'when the second unnassociated link already exists' do
        before do
          @link_two = Link.create(@link_two_params)
          @node_two.reload
          @node_two.upvotes_count.should == 1
          @node_two.downvotes_count.should == 0
          @link_two.users.should be_empty
          @link_two.users_count.should == 0
          @link_one.users_count.should == 1
        end
        it 'should remove the first association and create the second association' do
          @link_one.users.should include(@user)
          @user.update_association(@link_one, @link_two_params)
          @link_one.reload
          @link_two.reload
          @link_one.users.should_not include(@user)
          @link_two.users.should include(@user)
        end
        it 'should decrement the upvotes for node two and increment the downvotes' do
          upvotes_count = @node_two.upvotes_count 
          downvotes_count = @node_two.downvotes_count
          users_count = @link_one.users_count
          @user.update_association(@link_one, @link_two_params)
          @node_two.reload
          @link_one.reload
          @link_one.users_count.should == users_count - 1
          @node_two.downvotes_count.should == downvotes_count + 1
          @node_two.upvotes_count.should == upvotes_count - 1
        end
        it 'should return the newly associated link' do
          @user.update_association(@link_one, @link_two_params).attributes.to_s.should == @link_two.attributes.merge({"users_count"=>1}).to_s
        end
        #to make sure all updates of caches are correct
        it 'save the removed link' do

        end
        it 'save the newly associated link' do

        end
      end
      context 'when the second unnassociated link does not exist' do
        before do
          Link.find_by_node_from_id_and_value_and_node_to_id(@node_one.id,-1,@node_two.id).should be_nil
          @link_two = Link.new(@link_two_params)
          @node_two.upvotes_count.should == 1
          @node_two.downvotes_count.should == 0
          @link_one.users_count.should == 1
        end
        it 'should remove the first association and create the second association' do
          @link_one.users.should include(@user)
          @user.update_association(@link_one, @link_two_params)
          @link_one.reload
          @link_two = Link.find_by_node_from_id_and_value_and_node_to_id(@node_one.id,-1,@node_two.id)
          @link_one.users.should_not include(@user)
          @link_two.users.should include(@user)
        end
        it 'should decrement the upvotes for node two and increment the downvotes' do
          upvotes_count = @node_two.upvotes_count 
          downvotes_count = @node_two.downvotes_count
          users_count = @link_one.users_count
          @user.update_association(@link_one, @link_two_params)
          @node_two.reload
          @link_one.reload
          @link_one.users_count.should == users_count - 1
          @node_two.downvotes_count.should == downvotes_count + 1
          @node_two.upvotes_count.should == upvotes_count - 1
        end
        it 'should create the link' do
          @user.update_association(@link_one, @link_two_params)
          @link_two = Link.find_by_node_from_id_and_value_and_node_to_id(@node_one.id,-1,@node_two.id)
          @link_two.should be_persisted
        end
        it 'should return the newly associated link' do
          returned = @user.update_association(@link_one, @link_two_params)
          returned.attributes.merge(@link_two_params).should == returned.attributes
        end
      end
    end
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
  
  describe "creating and deleting links" do
    before do
      @user = Factory(:user)
      @node_one = Factory(:node)
      @node_two = Factory(:node, :title=>'title_two')
      @node_one.node_tos<< @node_two
      @link = Link.find_by_node_from_id_and_node_to_id(@node_one.id, @node_two.id)
      @count = @user.user_links.count
      @link.users << @user
      @link.save!
      @user.reload
      @link.reload
    end
    context "when adding a link" do
      it "should create the user link" do
        @user.links.count.should == @count+1
        @user.user_links.count.should == @count+1
      end
      it "should increment the counter cache" do
        @link.users_count.should == @count+1
      end
      context "when deleting the user" do
        before do
           @user.user_links.count.should == 1
           @user.links.count.should == 1
           @link.user_links.count.should == 1
           @link.users.count.should == 1
           @user.destroy 
           @link.reload
        end
        it "should reduce the user_links count by one" do
          @link.user_links.count.should == @count
        end
        it "should reduce the user_links count by one" do
          @link.users_count.should == @count
        end
      end
    end
  end

end
