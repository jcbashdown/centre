require 'spec_helper'

describe Link::GlobalLink do
  describe ".positive" do
    it "should return the correctly qualified class constant" do
      Link::GlobalLink.positive.should == Link::GlobalLink::PositiveGlobalLink
    end
  end
  describe ".negative" do
    it "should return the correctly qualified class constant" do
      Link::GlobalLink.negative.should == Link::GlobalLink::NegativeGlobalLink
    end
  end
end
