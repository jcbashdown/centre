require 'spec_helper'

describe GlobalNodeUser do
  before do
    @user = Factory(:user)
    @global = Factory(:global)
    @global2 = Factory(:global, :name => 'All')
  end
  describe 'creation' do
    describe 'creation with no existing inclusion in gns gnus' do
      it 'should create 2 globals_nodes' do
        expect {
          GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
        }.to change(GlobalNode, :count).by(1)
      end
      it 'should create 2 globals_nodes' do
        expect {
          GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
        }.to change(Node, :count).by(1)
      end
      it 'should create 2 global_node_users' do
        expect {
          GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
        }.to change(GlobalNodeUser, :count).by(1)
      end
      it 'should create 2 global_node_users' do
        expect {
          GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
        }.to change(NodeUser, :count).by(1)
      end
      it 'should create a globals_node for the global and node and all and node' do
        gnu = GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
        gnu2 = GlobalNodeUser.create(:user=>@user, :global=>@global2, :title => 'Title')
        nu = gnu.node_user
        nu2 = gnu2.node_user
        nu.should_not be_nil
        nu2.should_not be_nil
        nu.should == nu2
        nu.reload.global_node_users_count.should == 2 
      end
      it 'should create a globals_node for the global and node and all and node' do
        gnu = GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
        gnu2 = GlobalNodeUser.create(:user=>@user, :global=>@global2, :title => 'Title')
        gn = gnu.global_node
        gn2 = gnu2.global_node
        gn.should_not be_nil
        gn2.should_not be_nil
        gn.should_not == gn2
        gn.reload.global_node_users_count.should == 1 
        gn2.reload.global_node_users_count.should == 1 
      end
      it 'should create a globals_node_user for the global and node and all and node' do
        gnu = GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
        gnu.should be_persisted
        gnu.should be_a(GlobalNodeUser)
      end
    end
    describe 'creation with existing inclusion for all' do
      before do
        @gnu = GlobalNodeUser.create(:user=>@user, :global=>Global.find_by_name('All'), :title => 'Title')
      end
      context 'when in all' do
        before do
          @global = Global.find_by_name('All')
        end
        context 'when existing gnu' do
          it 'should create 0 globals_nodes' do
            expect {
              GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
            }.to change(GlobalNode, :count).by(0)
          end
          it 'should create 0 global_node_users' do
            expect {
              GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
            }.to change(GlobalNodeUser, :count).by(0)
          end
          it 'there should be only one gnu for this description' do
            gnu = GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id).count.should == 1
          end
        end
        context 'when new gnu' do
          before do
            @user = Factory(:user, :email=>"another@test.com")
          end
          it 'should create 0 globals_nodes' do
            expect {
              GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
            }.to change(GlobalNode, :count).by(0)
          end
          it 'should create 1 global_node_users' do
            expect {
              GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
            }.to change(GlobalNodeUser, :count).by(1)
          end
          it 'should create a globals_node_user for the global and node' do
            gnu = GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
            GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id).count.should == 1
          end
        end
      end
      context 'user has gnu for all' do
        context 'when outside of all with no existing gn/gnu' do
          it 'should create 1 globals_nodes' do
            expect {
              GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
            }.to change(GlobalNode, :count).by(1)
          end
          it 'should create 1 global_node_users' do
            expect {
              GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
            }.to change(GlobalNodeUser, :count).by(1)
          end
          it 'should create a globals_node for the global and node' do
            gnu = GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
            gnu.global_node.should_not be_nil
          end
          it 'should create a globals_node_user for the global and node' do
            gnu = GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
            GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id).count.should == 1
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
    context 'when there are no associated links' do
      describe 'when both the global nodes global node user count is less than two (when there is only this user for both)' do
        before do
          gnu = GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
          gnu_all = GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>Global.find_by_name('All').id)[0]
          gnu.global_node.reload.global_node_users_count.should == 1
          gnu_all.global_node.reload.global_node_users_count.should == 1
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
        it 'should destroy 2 globals_nodes_users' do
          expect {
            GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].destroy
          }.to change(NodeUser, :count).by(-1)
        end
        it 'should create a globals_node for the global and node and all and node' do
          gn = GlobalNode.where(:node_id=>@node.id, :global_id=>@global.id)[0]
          gn_all = GlobalNode.where(:node_id=>@node.id, :global_id=>Global.find_by_name('All').id)[0]
          gn.should_not be_nil
          gn_all.should_not be_nil
          GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].destroy
          gn = GlobalNode.where(:node_id=>@node.id, :global_id=>@global.id)[0]
          gn.should be_nil
          gn_all = GlobalNode.where(:node_id=>@node.id, :global_id=>Global.find_by_name('All').id)[0]
          gn_all.should be_nil
        end
        it 'should create a globals_node for the global and node and all and node' do
          GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].destroy
          nu = NodeUser.where(:node_id=>@node.id, :user_id=>@user.id)[0]
          nu.should be_nil
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
        context 'when destroying just the all gnu' do
          before do
            @global_orig = @global
            @global = Global.find_by_name('All')
          end
          it 'should destroy any unsused non all gnus or it should fail to destroy if these are used' do
            pending
          end
          it 'should destroy 2 globals_nodes' do
            expect {
              GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].destroy
            }.to change(GlobalNode, :count).by(-1)
          end
          it 'should destroy 2 globals_nodes_users' do
            expect {
              GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].destroy
            }.to change(GlobalNodeUser, :count).by(-1)
          end
          it 'should destroy 2 globals_nodes_users' do
            expect {
              GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].destroy
            }.to change(NodeUser, :count).by(0)
          end
          it 'should create a globals_node for the global and node and all and node' do
            gn = GlobalNode.where(:node_id=>@node.id, :global_id=>@global_orig.id)[0]
            gn_all = GlobalNode.where(:node_id=>@node.id, :global_id=>Global.find_by_name('All').id)[0]
            gn.should_not be_nil
            gn_all.should_not be_nil
            GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].destroy
            gn = GlobalNode.where(:node_id=>@node.id, :global_id=>@global_orig.id)[0]
            gn.should_not be_nil
            gn.global_node_users_count.should == 1
            gn_all = GlobalNode.where(:node_id=>@node.id, :global_id=>Global.find_by_name('All').id)[0]
            gn_all.should be_nil
          end
          it 'should create a globals_node for the global and node and all and node' do
            GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].destroy
            nu = NodeUser.where(:node_id=>@node.id, :user_id=>@user.id)[0]
            nu.should_not be_nil
            nu.global_node_users_count.should == 1
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
          it 'should not destroy the all unless there is only one other ugn for this user and this node and this has no links' do
            pending
          end
        end
        context 'with another user for the global node' do
          before do
            @user = Factory(:user, :email => "a@test.com")
            gnu = GlobalNodeUser.create(:user=>@user, :node=>@node, :global=>@global)
            gnu_all = GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>Global.find_by_name('All').id)[0]
            gnu.global_node.reload.global_node_users_count.should == 2
            gnu_all.global_node.reload.global_node_users_count.should == 2
          end
          it 'should destroy 2 globals_nodes' do
            expect {
              GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].destroy
            }.to change(GlobalNode, :count).by(0)
          end
          it 'should destroy 2 globals_nodes_users' do
            expect {
              GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].destroy
            }.to change(GlobalNodeUser, :count).by(-2)
          end
          it 'should destroy 2 globals_nodes_users' do
            expect {
              GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].destroy
            }.to change(NodeUser, :count).by(-1)
          end
          it 'should create a globals_node for the global and node and all and node' do
            gn = GlobalNode.where(:node_id=>@node.id, :global_id=>@global.id)[0]
            gn_all = GlobalNode.where(:node_id=>@node.id, :global_id=>Global.find_by_name('All').id)[0]
            gn.should_not be_nil
            gn_all.should_not be_nil
            GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].destroy
            gn = GlobalNode.where(:node_id=>@node.id, :global_id=>@global.id)[0]
            gn.should_not be_nil
            gn.global_node_users_count.should == 1
            gn_all = GlobalNode.where(:node_id=>@node.id, :global_id=>Global.find_by_name('All').id)[0]
            gn_all.should_not be_nil
            gn_all.global_node_users_count.should == 1
          end
          it 'should create a globals_node for the global and node and all and node' do
            GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].destroy
            nu = NodeUser.where(:node_id=>@node.id, :user_id=>@user.id)[0]
            nu.should be_nil
          end
          it 'should destroy a globals_node_user for the global and node and all and node' do
            GlobalNodeUser.where(:user_id=>@user.id, :node_id=>@node.id, :global_id=>@global.id)[0].destroy
            GlobalNodeUser.where(:node_id=>@node.id, :global_id=>@global.id)[0].should_not be_nil
            GlobalNodeUser.where(:node_id=>@node.id, :user_id => @user.id, :global_id=>@global.id)[0].should be_nil
            GlobalNodeUser.where(:node_id=>@node.id, :global_id=>Global.find_by_name('All').id)[0].should_not be_nil
            GlobalNodeUser.where(:node_id=>@node.id, :user_id => @user.id, :global_id=>Global.find_by_name('All').id)[0].should be_nil
          end
        end
        #with other users should decrement counter caches
      end
    end
    describe 'with existing links' do
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
    end
  end
end
