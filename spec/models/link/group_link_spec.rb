require 'spec_helper'

describe Link::GroupLink do

  describe "validations" do
    context "when the group_link has a user" do
      subject {Link::GroupLink.new(:user_id => 1)}
      it {should_not be_valid}
    end
    context "when the group_link has a group" do
      subject {Link::GroupLink.new(:group_id => 1)}
      it {should be_valid}
    end
    context "when the group_link has no user or question" do
      subject {Link::GroupLink.new(:user_id => nil, :group_id => nil)}
      it {should_not be_valid}
    end

  end
end
