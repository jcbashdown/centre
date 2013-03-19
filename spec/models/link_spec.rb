require "spec_helper"

describe Link do
  describe ".positive" do
    it "should return the correctly qualified class constant" do
      Link.should_receive(:where).with("type LIKE '%Positive%'")
      Link.positive
    end
  end
  describe ".negative" do
    it "should return the correctly qualified class constant" do
      Link.should_receive(:where).with("type LIKE '%Negative%'")
      Link.negative
    end
  end
end
