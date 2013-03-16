require 'spec_helper'

describe Link::UserLink do
  describe ".positive" do
    it "should return the correctly qualified class constant" do
      Link::UserLink.positive.should == Link::UserLink::PositiveUserLink
    end
  end
  describe ".negative" do
    it "should return the correctly qualified class constant" do
      Link::UserLink.negative.should == Link::UserLink::NegativeUserLink
    end
  end
end
