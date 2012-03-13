require 'spec_helper'

describe Link do
  describe "on validation" do
    it "should limit to one for each value, from and to combination" do
      pending
    end  
  end
  describe "on creation" do
    before do
      @global = Factory(:global)
      @node_one = Factory(:node)
      @node_two = Factory(:node, :title=>'title two')
      @nodes_global1 = Factory(:nodes_global, :node=>@node_one, :global=>@global)
      @nodes_global2 = Factory(:nodes_global, :node=>@node_two, :global=>@global)
      @link = Link.create(:node_from => @node_one, :nodes_global_from=>@nodes_global1, :node_to=> @node_two, :nodes_global_to=>@nodes_global2)
      @user = Factory(:user)
      @link.users <<  @user
      @nodes_global2.upvotes_count.should == 0
      @link.users_count.should == 1
    end
    context "when the link is positive" do
      before do
        @link.update_attributes!(:value=>-1)
        @node_two.reload
        @count = @node_two.upvotes_count
        @link.update_attributes!(:value=>1)
        @node_two.reload
      end
      it "should increment the upvote counter cache on the node" do
        @nodes_global2.upvotes_count.should == @count+1
        @node_two.upvotes_count.should == @count+1
      end
    end
    context "when the link is negative" do
      before do
        @link.update_attributes!(:value=>1)
        @node_two.reload
        @count = @node_two.downvotes_count
        @link.update_attributes!(:value=>-1)
        @node_two.reload
      end
      it "should increment the downvote counter cache on the node" do
        @node_two.downvotes_count.should == @count+1
        @nodes_global2.downvotes_count.should == @count+1
      end
    end
    context "when the link is equality" do
      before do
        @link.update_attributes!(:value=>-1)
        @node_two.reload
        @count = @node_two.equivalents_count
        @link.update_attributes!(:value=>0)
        @node_two.reload
      end
      it "should increment the equality counter cache on the node" do
        @node_two.equivalents_count.should == @count+1
        @nodes_global2.equivalents_count.should == @count+1
      end
    end
    describe "on deletion" do
      context "when the link is positive" do
        before do
          @link.update_attributes!(:value=>1)
          @node_two.reload
          @count = @node_two.upvotes_count
        end
        it "should decrement the upvote counter cache on the node" do
          @link.destroy
          @node_two.reload
          @node_two.upvotes_count.should == @count-1
          @nodes_global2.upvotes_count.should == @count-1
        end
      end
      context "when the link is negative" do
        before do
          @link.update_attributes!(:value=>-1)
          @node_two.reload
          @count = @node_two.downvotes_count
        end
        it "should decrement the downvote counter cache on the node" do
          @link.destroy
          @node_two.reload
          @node_two.downvotes_count.should == @count-1
          @nodes_global2.downvotes_count.should == @count-1
        end
      end
      context "when the link is equal" do
        before do
          @link.update_attributes!(:value=>0)
          @node_two.reload
          @count = @node_two.equivalents_count
        end
        it "should decrement the downvote counter cache on the node" do
          @link.destroy
          @node_two.reload
          @node_two.equivalents_count.should == @count-1
          @nodes_global2.equivalents_count.should == @count-1
        end
      end
    end
  end
end
