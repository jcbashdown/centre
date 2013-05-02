require 'spec_helper'

describe Group do
  context 'instance_methods' do
    describe '#user_ids' do
      let(:group) {Group.new}
      let(:users) {[User.new,User.new]}
      before do
        @ids = []
        users.each_with_index do |user, i|
          user.stub(:id).and_return i
          @ids << i
        end
        group.stub(:users).and_return users
      end
      it "should map the groups user_ids" do
        group.user_ids.should == @ids
      end
    end
  end

  context "class methods" do
    subject {Group}
    describe '.user_ids_for' do
      let(:mock_group) {mock('group')}
      let(:id) {1}
      before {Group.stub(:find).and_return mock_group}
      it "should call user_ids on the group found by id" do
        mock_group.should_receive(:user_ids)
        subject.user_ids_for id
      end
    end
  end
end
