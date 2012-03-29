require 'spec_helper'

describe GlobalNodeUser do
  before do
    @user = Factory(:user)
    @node= Factory(:node)
    @global = Factory(:global)
  end
  describe 'creation' do
    describe 'creation with no existing inclusion in gns gnus' do
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
      it 'should create 2 global_node_users' do
        expect {
          GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
        }.to change(NodeUser, :count).by(1)
      end
      it 'should create a globals_node for the global and node and all and node' do
        GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
        gn = GlobalNode.where(:node_id=>@node.id, :global_id=>@global.id)[0]
        gn.should_not be_nil
        gn.global_node_users_count.should == 1
        gn_all = GlobalNode.where(:node_id=>@node.id, :global_id=>Global.find_by_name('All').id)[0]
        gn_all.should_not be_nil
        gn_all.global_node_users_count.should == 1
      end
      it 'should create a globals_node for the global and node and all and node' do
        GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
        gl = GlobalLink.where(:node_id=>@node.id, :global_id=>@global.id)[0]
        gl.should_not be_nil
        gl.global_node_users_count.should == 2
      end
      it 'should create a globals_node_user for the global and node and all and node' do
        GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
        GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].should_not be_nil
        GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>Global.find_by_name('All').id)[0].should_not be_nil
      end
    end
    describe 'creation with existing inclusion for all' do
      before do
        @gnu = GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>Global.find_by_name('All'))
      end
      context 'when in all' do
        before do
          @global = Global.find_by_name('All')
        end
        context 'when existing gnu' do
          it 'should create 0 globals_nodes' do
            expect {
              GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            }.to change(GlobalNode, :count).by(0)
          end
          it 'should create 0 global_node_users' do
            expect {
              GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            }.to change(GlobalNodeUser, :count).by(0)
          end
          it 'there should be only one gnu for this description' do
            GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id).count.should == 1
          end
        end
        context 'when new gnu' do
          before do
            @user = Factory(:user, :email=>"another@test.com")
          end
          it 'should create 0 globals_nodes' do
            expect {
              GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            }.to change(GlobalNode, :count).by(0)
          end
          it 'should create 1 global_node_users' do
            expect {
              GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            }.to change(GlobalNodeUser, :count).by(1)
          end
          it 'should create a globals_node_user for the global and node' do
            GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].should_not be_nil
          end
        end
      end
      context 'user has gnu for all' do
        context 'when outside of all with no existing gn/gnu' do
          it 'should create 1 globals_nodes' do
            expect {
              GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            }.to change(GlobalNode, :count).by(1)
          end
          it 'should create 1 global_node_users' do
            expect {
              GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            }.to change(GlobalNodeUser, :count).by(1)
          end
          it 'should create a globals_node for the global and node' do
            GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            GlobalNode.where(:node_id=>@node.id, :global_id=>@global.id)[0].should_not be_nil
          end
          it 'should create a globals_node_user for the global and node' do
            GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].should_not be_nil
          end
        end
        context 'when outside of all with existing gn' do
          before do
            @new_user = Factory(:user, :email=>"another@test.com")
            GlobalNodeUser.create(:user=>@new_user, :node=>@node, :global=>@global)
          end
          it 'should create 0 globals_nodes' do
            expect {
              GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            }.to change(GlobalNode, :count).by(0)
          end
          it 'should create 1 global_node_users' do
            expect {
              GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            }.to change(GlobalNodeUser, :count).by(1)
          end
          it 'should create a globals_node_user for the global and node' do
            GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].should_not be_nil
          end
        end
        context 'when outside of all with existing gn/gnu' do
          before do
            GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
          end
          it 'should create 0 globals_nodes' do
            expect {
              GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            }.to change(GlobalNode, :count).by(0)
          end
          it 'should create 0 global_node_users' do
            expect {
              GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            }.to change(GlobalNodeUser, :count).by(0)
          end
          it 'there should be only one gnu for this description' do
            GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id).count.should == 1
          end
        end
      end
      context 'user has no gnu for all' do
        before do
          @user = Factory(:user, :email=>"another@test.com")
        end
        context 'when outside of all with no existing gn/gnu' do
          it 'should create 1 globals_nodes' do
            expect {
              GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            }.to change(GlobalNode, :count).by(1)
          end
          it 'should create 2 global_node_users' do
            expect {
              GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            }.to change(GlobalNodeUser, :count).by(2)
          end
          it 'should create a globals_node for the global and node' do
            GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            GlobalNode.where(:node_id=>@node.id, :global_id=>@global.id)[0].should_not be_nil
          end
          it 'should create a globals_node_user for the global and node' do
            GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].should_not be_nil
          end
        end
        context 'when outside of all with existing gn' do
          before do
            @new_user = Factory(:user, :email=>"afurther@test.com")
            GlobalNodeUser.create(:user=>@new_user, :node=>@node, :global=>@global)
          end
          it 'should create 0 globals_nodes' do
            expect {
              GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            }.to change(GlobalNode, :count).by(0)
          end
          it 'should create 2 global_node_users' do
            expect {
              GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            }.to change(GlobalNodeUser, :count).by(2)
          end
          it 'should create a globals_node_user for the global and node' do
            GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].should_not be_nil
          end
        end
        context 'when outside of all with existing gn/gnu' do
          before do
            GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
          end
          it 'should create 0 globals_nodes' do
            expect {
              GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            }.to change(GlobalNode, :count).by(0)
          end
          it 'should create 0 global_node_users' do
            expect {
              GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            }.to change(GlobalNodeUser, :count).by(0)
          end
          it 'there should be only one gnu for this description' do
            GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id).count.should == 1
          end
        end
      end
    end
    describe 'creation with existing inclusion in current gn and gnu when no all' do
      #should never happen
    end
  end
  describe 'deletion' do
    it 'should destroy the current user links for this node' do

    end

    it 'should destroy the current gnu' do

    end

    context 'when only this user has a link the node features in' do
      it 'should destroy the link and global links' do
        #call backs on links should unravel any link stuff

      end
      context 'when only this user has the node' do
        it 'should destroy the node and global nodes' do

        end
      end
    end

    context 'when only this user has the node' do
      it 'should destroy the node and global nodes' do

      end

      context 'when only this user has a link the node features in' do
        #call backs on links should unravel any link stuff
        it 'should destroy the link and global links' do

        end

      end
    end
    #describe 'deletion with only 2 globals for the current node (all and current)' do
      #before do
        #GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
      #end
#      it 'should destroy 2 globals_nodes' do
#        expect {
#          GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].destroy
#        }.to change(GlobalNode, :count).by(-2)
#      end
#      it 'should destroy 2 globals_nodes_users' do
#        expect {
#          GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].destroy
#        }.to change(GlobalNodeUser, :count).by(-2)
#      end
#      it 'should destroy a globals_node for the global and node and all and node' do
#        GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].destroy
#        GlobalNode.where(:node_id=>@node.id, :global_id=>@global.id)[0].should be_nil
#        GlobalNode.where(:node_id=>@node.id, :global_id=>Global.find_by_name('All').id)[0].should be_nil
#      end
#      it 'should destroy a globals_node_user for the global and node and all and node' do
#        GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].destroy
#        GlobalNodeUser.where(:node_id=>@node.id, :global_id=>@global.id)[0].should be_nil
#        GlobalNodeUser.where(:node_id=>@node.id, :global_id=>Global.find_by_name('All').id)[0].should be_nil
#      end
    #end
  end
end
