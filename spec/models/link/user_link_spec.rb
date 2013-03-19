require 'spec_helper'

describe Link::UserLink do

  describe "validations" do
    context "when the user_link has a user" do
      subject {Link::UserLink.new(:user_id => 1)}
      it {should be_valid}
    end
    context "when the user_link has a group" do
      subject {Link::UserLink.new(:group_id => 1)}
      it {should_not be_valid}
    end
    context "when the user_link has no user or question" do
      subject {Link::UserLink.new(:user_id => nil, :group_id => nil)}
      it {should_not be_valid}
    end

  end
end
