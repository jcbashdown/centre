require 'spec_helper'

describe Link do
  describe "on validation" do
    it "should limit to one for each value, from and to combination" do
      pending
    end  
  end
  describe "on creation" do
    context "when the link is positive" do
      before do
        @link = Factory(:link, :value=>1)
      end
      it "should increment the upvote counter cache on the node" do
        pending 
      end
    end
    context "when the link is negative" do
      before do
        
      end
      it "should increment the downvote counter cache on the node" do
        pending
      end
    end
    context "when the link is equality" do
      before do
        
      end
      it "should increment the equality counter cache on the node" do
        pending 
      end
    end
  end
  describe "on deletion" do
    context "when the link is positive" do
      before do
        
      end
      it "should increment the upvote counter cache on the node" do
        pending 
      end
    end
    context "when the link is negative" do
      before do
        
      end
      it "should increment the downvote counter cache on the node" do
        pending 
      end
    end
  end
end
