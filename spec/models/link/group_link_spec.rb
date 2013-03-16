require 'spec_helper'

describe Link::GroupLink do
  describe ".positive" do
    it "should return the correctly qualified class constant" do
      Link::GroupLink.positive.should == Link::GroupLink::PositiveGroupLink
    end
  end
  describe ".negative" do
    it "should return the correctly qualified class constant" do
      Link::GroupLink.negative.should == Link::GroupLink::NegativeGroupLink
    end
  end
end
