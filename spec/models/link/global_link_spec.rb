require 'spec_helper'

describe Link::GlobalLink do

  describe "validations" do
    context "when the global_link has a user" do
      subject {Link::GlobalLink.new(:user_id => 1)}
      it {should_not be_valid}
    end
    context "when the global_link has a group" do
      subject {Link::GlobalLink.new(:group_id => 1)}
      it {should_not be_valid}
    end
    context "when the global_link has no user or question" do
      subject {Link::GlobalLink.new(:user_id => nil, :group_id => nil)}
      it {subject.should be_valid}
    end

  end
end