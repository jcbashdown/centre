require 'spec_helper'

describe GlobalNodeUser do
  before do
    @user = Factory(:user)
    @node= Factory(:node)
    @global = Factory(:global)
  end
  describe 'creation' do
    it 'should create 2 globals_nodes' do
      expect {
        GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
      }.to change(GlobalNode, :count).by(2)
    end
    it 'should create 2 global_node_users' do
      expect {
        GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
      }.to change(GlobalNodeUser, :count).by(2)
    end
    it 'should create a globals_node for the global and node and all and node' do
      GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
      GlobalNode.where(:node_id=>@node.id, :global_id=>@global.id)[0].should_not be_nil
      GlobalNode.where(:node_id=>@node.id, :global_id=>Global.find_by_name('All').id)[0].should_not be_nil
    end
    it 'should create a globals_node_user for the global and node and all and node' do
      GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
      GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].should_not be_nil
      GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>Global.find_by_name('All').id)[0].should_not be_nil
    end
  end
  describe 'deletion with only 2 globals for the current node (all and current)' do
    before do
      GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
      p GlobalNodeUser.count
      p GlobalNode.count
    end
    it 'should destroy 2 globals_nodes' do
      expect {
        GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].destroy
      }.to change(GlobalNode, :count).by(-2)
    end
    it 'should destroy 2 globals_nodes_users' do
      expect {
        GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].destroy
      }.to change(GlobalNodeUser, :count).by(-2)
    end
    it 'should destroy a globals_node for the global and node and all and node' do
      GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].destroy
      GlobalNode.where(:node_id=>@node.id, :global_id=>@global.id)[0].should be_nil
      GlobalNode.where(:node_id=>@node.id, :global_id=>Global.find_by_name('All').id)[0].should be_nil
    end
    it 'should destroy a globals_node_user for the global and node and all and node' do
      GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].destroy
      GlobalNodeUser.where(:node_id=>@node.id, :global_id=>@global.id)[0].should be_nil
      GlobalNodeUser.where(:node_id=>@node.id, :global_id=>Global.find_by_name('All').id)[0].should be_nil
    end
  end
end
