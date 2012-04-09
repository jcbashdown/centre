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
    describe 'creation with existing nu' do
      before do
        @gnu = GlobalNodeUser.create(:user=>@user, :global=>Global.find_by_name('All'), :title => 'Title')
        @gnu.node_user.should_not be_nil
      end
      context 'when in the global' do
        before do
          @global = Global.find_by_name('All')
        end
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
        it 'should create 0 node_users' do
          expect {
            GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
          }.to change(NodeUser, :count).by(0)
        end
        it 'there should be only one gnu etc for this description' do
          gnu = GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
          GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id).count.should == 1
          NodeUser.where(:user_id=>@user.id, :title=>'Title').count.should == 1
          GlobalNode.where(:title=>'Title', :global_id=>@global.id).count.should == 1
        end
        context 'when new user' do
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
          it 'should create 1 node_users' do
            expect {
              GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
            }.to change(NodeUser, :count).by(1)
          end
          it 'should create a globals_node_user etc' do
            gnu = GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
            GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id).count.should == 1
            NodeUser.where(:user_id=>@user.id, :title=>'Title').count.should == 1
            GlobalNode.where(:title=>'Title', :global_id=>@global.id).count.should == 1
          end
        end
      end
      context 'when outside of the global' do
        context 'when existing nu' do
          before do
            NodeUser.where(:user_id=>@user.id, :title => 'Title').count.should == 1
          end
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
          it 'should create 1 node_users' do
            expect {
              GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
            }.to change(NodeUser, :count).by(0)
          end
          it 'should create a globals_node_user etc for the global and node' do
            gnu = GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
            GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id).count.should == 1
            NodeUser.where(:user_id=>@user.id, :title=>'Title').count.should == 1
            GlobalNode.where(:title=>'Title', :global_id=>@global.id).count.should == 1
          end
        end
        context 'when no existing nu' do
          before do
            @user = Factory(:user, :email=>"another@test.com")
          end
          it 'should create 0 globals_nodes' do
            expect {
              GlobalNodeUser.create(:user=>@user, :title=>'Title', :global=>@global)
            }.to change(GlobalNode, :count).by(1)
          end
          it 'should create 1 global_node_users' do
            expect {
              GlobalNodeUser.create(:user=>@user, :title=>'Title', :global=>@global)
            }.to change(GlobalNodeUser, :count).by(1)
          end
          it 'should create 1 node_users' do
            expect {
              GlobalNodeUser.create(:user=>@user, :title=>'Title', :global=>@global)
            }.to change(NodeUser, :count).by(1)
          end
          it 'should create a globals_node_user etc for the global and node' do
            gnu = GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
            GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id).count.should == 1
            NodeUser.where(:user_id=>@user.id, :title=>'Title').count.should == 1
            GlobalNode.where(:title=>'Title', :global_id=>@global.id).count.should == 1
          end
        end
      end
    end
  end
  describe 'deletion' do
    context 'when there are no associated links' do
      describe 'when the global nodes global node user count is less than two (when there is only this user)' do
        before do
          gnu = GlobalNodeUser.create(:user=>@user, :title=>'Title', :global=>@global)
          gnu.global_node.reload.global_node_users_count.should == 1
        end
        it 'should destroy 1 node' do
          expect {
            GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id)[0].destroy
          }.to change(Node, :count).by(-1)
        end
        it 'should destroy 1 globals_nodes' do
          expect {
            GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id)[0].destroy
          }.to change(GlobalNode, :count).by(-1)
        end
        it 'should destroy 1 globals_nodes_users' do
          expect {
            GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id)[0].destroy
          }.to change(GlobalNodeUser, :count).by(-1)
        end
        it 'should destroy 1 globals_nodes_users' do
          expect {
            GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id)[0].destroy
          }.to change(NodeUser, :count).by(-1)
        end
        it 'should create a globals_node for the global and node and all and node' do
          gn = GlobalNode.where(:title=>'Title', :global_id=>@global.id)[0]
          gn.should_not be_nil
          GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id)[0].destroy
          gn = GlobalNode.where(:title=>'Title', :global_id=>@global.id)[0]
          gn.should be_nil
        end
        it 'should create a globals_node for the global and node and all and node' do
          GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id)[0].destroy
          nu = NodeUser.where(:title=>'Title', :user_id=>@user.id)[0]
          nu.should be_nil
        end
        it 'should destroy a globals_node for the global and node and all and node' do
          GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id)[0].destroy
          GlobalNode.where(:title=>'Title', :global_id=>@global.id)[0].should be_nil
        end
        it 'should destroy a globals_node_user for the global and node and all and node' do
          GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id)[0].destroy
          GlobalNodeUser.where(:title=>'Title', :global_id=>@global.id)[0].should be_nil
        end
        context 'with another user for the global node' do
          before do
            @user = Factory(:user, :email => "a@test.com")
            gnu = GlobalNodeUser.create(:user=>@user, :title=>'Title', :global=>@global)
            gnu.global_node.reload.global_node_users_count.should == 2
          end
          it 'should destroy 0 globals_nodes' do
            expect {
              GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id)[0].destroy
            }.to change(Node, :count).by(0)
          end
          it 'should destroy 0 globals_nodes' do
            expect {
              GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id)[0].destroy
            }.to change(GlobalNode, :count).by(0)
          end
          it 'should destroy 1 globals_nodes_users' do
            expect {
              GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id)[0].destroy
            }.to change(GlobalNodeUser, :count).by(-1)
          end
          it 'should destroy 1 nodes_users' do
            expect {
              GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id)[0].destroy
            }.to change(NodeUser, :count).by(-1)
          end
          it 'should create a globals_node for the global and node and all and node' do
            gn = GlobalNode.where(:title=>'Title', :global_id=>@global.id)[0]
            gn.should_not be_nil
            GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id)[0].destroy
            gn = GlobalNode.where(:title=>'Title', :global_id=>@global.id)[0]
            gn.should_not be_nil
            gn.global_node_users_count.should == 1
            gn.node.global_node_users_count.should == 1
          end
          it 'should create a globals_node for the global and node and all and node' do
            GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id)[0].destroy
            nu = NodeUser.where(:title=>'Title', :user_id=>@user.id)[0]
            nu.should be_nil
          end
          it 'should destroy a globals_node_user for the global and node and all and node' do
            GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id)[0].destroy
            GlobalNode.where(:title=>'Title', :global_id=>@global.id)[0].should_not be_nil
            GlobalNodeUser.where(:title=>'Title', :user_id => @user.id, :global_id=>@global.id)[0].should be_nil
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
