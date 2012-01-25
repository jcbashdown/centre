require 'spec_helper'

describe Link do
  describe "on validation" do
    it "should limit to one for each value, from and to combination" do
      pending
    end  
  end
  describe "on creation" do
    before do
      @node_one = Factory(:node)
      @node_two = Factory(:node)
      @node_two.source_nodes << @node_one
      @link = Link.find_by_node_from_and_node_to(@node_one.id, @node_two.id)
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
        end
      end
    end
  end
end
