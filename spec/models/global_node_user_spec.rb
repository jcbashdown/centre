require 'spec_helper'

describe GlobalNodeUser do
  before do
    @user = FactoryGirl.create(:user)
    @user_two = FactoryGirl.create(:user, :email => "test@email.com")
    @global = FactoryGirl.create(:global)
    @global2 = FactoryGirl.create(:global, :name => 'Aaa')
  end

  describe 'gnus created in all global' do

    it 'should set the global to unclassified' do
      pending
    end

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
        @gnu = GlobalNodeUser.create(:user=>@user, :global=>Global.find_by_name('All'), :title => 'Title', :is_conclusion => false)
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
          GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id, :is_conclusion => false).count.should == 1
          NodeUser.where(:user_id=>@user.id, :title=>'Title', :is_conclusion => false).count.should == 1
          GlobalNode.where(:title=>'Title', :global_id=>@global.id, :is_conclusion => false).count.should == 1
          gnu = GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title')
          GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id, :is_conclusion => false).count.should == 1
          NodeUser.where(:user_id=>@user.id, :title=>'Title', :is_conclusion => false).count.should == 1
          GlobalNode.where(:title=>'Title', :global_id=>@global.id, :is_conclusion => false).count.should == 1
        end
        context 'when new user' do
          before do
            @user = FactoryGirl.create(:user, :email=>"another@test.com")
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
            gnu = GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title', :is_conclusion => true)
            GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id, :is_conclusion => true).count.should == 1
            NodeUser.where(:user_id=>@user.id, :title=>'Title', :is_conclusion => true).count.should == 1
            GlobalNode.where(:title=>'Title', :global_id=>@global.id, :is_conclusion => true).count.should == 0
            @user = FactoryGirl.create(:user, :email=>"another@test2.com")
            gnu = GlobalNodeUser.create(:user=>@user, :global=>@global, :title => 'Title', :is_conclusion => true)
            GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id, :is_conclusion => true).count.should == 1
            NodeUser.where(:user_id=>@user.id, :title=>'Title', :is_conclusion => true).count.should == 1
            GlobalNode.where(:title=>'Title', :global_id=>@global.id, :is_conclusion => true).count.should == 1
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
            @user = FactoryGirl.create(:user, :email=>"another@test.com")
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
          gnu = GlobalNodeUser.create(:user=>@user, :title=>'Title', :global=>@global, :is_conclusion => false)
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
        it 'should destroy the global node' do
          gn = GlobalNode.where(:title=>'Title', :global_id=>@global.id)[0]
          gn.should_not be_nil
          GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id)[0].destroy
          gn = GlobalNode.where(:title=>'Title', :global_id=>@global.id)[0]
          gn.should be_nil
        end
        it 'should destroy the node user' do
          GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id)[0].destroy
          nu = NodeUser.where(:title=>'Title', :user_id=>@user.id)[0]
          nu.should be_nil
        end
        it 'should destroy the node' do
          GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id)[0].destroy
          Node.where(:title=>'Title')[0].should be_nil
        end
        it 'should destroy the global node user' do
          GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id)[0].destroy
          GlobalNodeUser.where(:title=>'Title', :global_id=>@global.id)[0].should be_nil
        end
        context 'with another user for the global node' do
          before do
            @user = FactoryGirl.create(:user, :email => "a@test.com")
            gnu = GlobalNodeUser.create(:user=>@user, :title=>'Title', :global=>@global, :is_conclusion => false)
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
          it 'should update the caches' do
            gn = GlobalNode.where(:title=>'Title', :global_id=>@global.id)[0]
            gn.should_not be_nil
            GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id)[0].destroy
            gn = GlobalNode.where(:title=>'Title', :global_id=>@global.id)[0]
            gn.should_not be_nil
            gn.global_node_users_count.should == 1
            gn.node.global_node_users_count.should == 1
          end
          it 'should destroy the node user' do
            GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id)[0].destroy
            nu = NodeUser.where(:title=>'Title', :user_id=>@user.id)[0]
            nu.should be_nil
          end
          it 'should not destroy the node and global node and should destroy the gnu' do
            @user_two = FactoryGirl.create(:user, :email=>"another@test.com")
            gnu = GlobalNodeUser.create(:user=>@user_two, :global=>@global, :title => 'Title', :is_conclusion => true)
            GlobalNodeUser.where(:user_id=>@user_two.id, :title=>'Title', :global_id=>@global.id, :is_conclusion => true).count.should == 1
            NodeUser.where(:user_id=>@user_two.id, :title=>'Title', :is_conclusion => true).count.should == 1
            GlobalNode.where(:title=>'Title', :global_id=>@global.id, :is_conclusion => true).count.should == 0
            @user_three = FactoryGirl.create(:user, :email=>"another@test2.com")
            gnu = GlobalNodeUser.create(:user=>@user_three, :global=>@global, :title => 'Title', :is_conclusion => true)
            GlobalNodeUser.where(:user_id=>@user_three.id, :title=>'Title', :global_id=>@global.id, :is_conclusion => true).count.should == 1
            NodeUser.where(:user_id=>@user_three.id, :title=>'Title', :is_conclusion => true).count.should == 1
            GlobalNode.where(:title=>'Title', :global_id=>@global.id, :is_conclusion => true).count.should == 0
            GlobalNodeUser.where(:user_id=>@user.id, :title=>'Title', :global_id=>@global.id)[0].destroy
            GlobalNode.where(:title=>'Title', :global_id=>@global.id, :is_conclusion => true)[0].should_not be_nil
            Node.where(:title=>'Title')[0].should_not be_nil
            GlobalNodeUser.where(:title=>'Title', :user_id => @user.id, :global_id=>@global.id)[0].should be_nil
          end
        end
      end
    end
    describe 'with existing links' do
      before do
        @gnu1 = GlobalNodeUser.create(:title => 'title', :global => @global, :user => @user)
        @gnu2 = GlobalNodeUser.create(:title => 'test', :global => @global, :user => @user)
        @gnu3 = GlobalNodeUser.create(:title => 'another', :global => @global, :user => @user)
        @glu = GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
      end
      it 'should destroy 1 node' do
        expect {
          @gnu1.destroy
        }.to change(Node, :count).by(-1)
      end
      it 'should destroy 1 globals_nodes' do
        expect {
          @gnu1.destroy
        }.to change(GlobalNode, :count).by(-1)
      end
      it 'should destroy 1 globals_nodes_users' do
        expect {
          @gnu1.destroy
        }.to change(GlobalNodeUser, :count).by(-1)
      end
      it 'should destroy 1 nodes_users' do
        expect {
          @gnu1.destroy
        }.to change(NodeUser, :count).by(-1)
      end

      it 'should destroy 1 link' do
        expect {
          @gnu1.destroy
        }.to change(Link, :count).by(-1)
      end

      it 'should destroy 1 glu' do
        expect {
          @gnu1.destroy
        }.to change(GlobalLinkUser, :count).by(-1)
      end

      it 'should destroy 1 glu' do
        expect {
          @gnu1.destroy
        }.to change(GlobalLink, :count).by(-1)
      end

      it 'should destroy 1 glu' do
        expect {
          @gnu1.destroy
        }.to change(LinkUser, :count).by(-1)
      end

      it 'update the caches' do
        @gnu2.reload.upvotes_count.should == 1
        @gnu2.node_user.reload.upvotes_count.should == 1
        @gnu2.global_node.reload.upvotes_count.should == 1
        @gnu2.node.reload.upvotes_count.should == 1
        @gnu1.destroy
        @gnu2.reload.upvotes_count.should == 0 
        @gnu2.node_user.reload.upvotes_count.should == 0
        @gnu2.global_node.reload.upvotes_count.should == 0
        @gnu2.node.reload.upvotes_count.should == 0
      end
      
      context 'when another user has the link in this global' do
        before do
          @glu2 = GlobalLinkUser.create(:user=>@user_two, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        end
        it 'should destroy 0 node' do
          expect {
            @gnu1.destroy
          }.to change(Node, :count).by(0)
        end
        it 'should destroy 0 globals_nodes' do
          expect {
            @gnu1.destroy
          }.to change(GlobalNode, :count).by(0)
        end
        it 'should destroy 1 globals_nodes_users' do
          expect {
            @gnu1.destroy
          }.to change(GlobalNodeUser, :count).by(-1)
        end
        it 'should destroy 1 nodes_users' do
          expect {
            @gnu1.destroy
          }.to change(NodeUser, :count).by(-1)
        end
  
        it 'should destroy 0 link' do
          expect {
            @gnu1.destroy
          }.to change(Link, :count).by(0)
        end
  
        it 'should destroy 1 glu' do
          expect {
            @gnu1.destroy
          }.to change(GlobalLinkUser, :count).by(-1)
        end
  
        it 'should destroy 0 gl' do
          expect {
            @gnu1.destroy
          }.to change(GlobalLink, :count).by(0)
        end
  
        it 'should destroy 1 lu' do
          expect {
            @gnu1.destroy
          }.to change(LinkUser, :count).by(-1)
        end
  
        it 'update the caches' do
          @gnu2.reload.upvotes_count.should == 1
          @gnu2.node_user.reload.upvotes_count.should == 1
          @gnu2.global_node.reload.upvotes_count.should == 2
          @gnu2.node.reload.upvotes_count.should == 2
          @gnu1.destroy
          @gnu2.reload.upvotes_count.should == 0 
          @gnu2.node_user.reload.upvotes_count.should == 0
          @gnu2.global_node.reload.upvotes_count.should == 1
          @gnu2.node.reload.upvotes_count.should == 1
        end
      end
  
      context 'when another user has another link in this global which uses the same node from' do
        before do
          @glu2 = GlobalLinkUser.create(:user=>@user_two, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu3.node.id, :value => 1)
        end
        it 'should destroy 0 node (due to shared node from and diff users)' do
          expect {
            @gnu1.destroy
          }.to change(Node, :count).by(0)
        end
        it 'should destroy 0 globals_nodes' do
          expect {
            @gnu1.destroy
          }.to change(GlobalNode, :count).by(0)
        end
        it 'should destroy 1 globals_nodes_users' do
          expect {
            @gnu1.destroy
          }.to change(GlobalNodeUser, :count).by(-1)
        end
        it 'should destroy 1 nodes_users' do
          expect {
            @gnu1.destroy
          }.to change(NodeUser, :count).by(-1)
        end
  
        it 'should destroy 1 link' do
          expect {
            @gnu1.destroy
          }.to change(Link, :count).by(-1)
        end
  
        it 'should destroy 1 glu' do
          expect {
            @gnu1.destroy
          }.to change(GlobalLinkUser, :count).by(-1)
        end
  
        it 'should destroy 1 gl' do
          expect {
            @gnu1.destroy
          }.to change(GlobalLink, :count).by(-1)
        end
  
        it 'should destroy 1 lu' do
          expect {
            @gnu1.destroy
          }.to change(LinkUser, :count).by(-1)
        end
  
        it 'update the caches' do
          @gnu2.reload.upvotes_count.should == 1
          @gnu2.node_user.reload.upvotes_count.should == 1
          @gnu2.global_node.reload.upvotes_count.should == 1
          @gnu2.node.reload.upvotes_count.should == 1
          @gnu1.destroy
          @gnu2.reload.upvotes_count.should == 0 
          @gnu2.node_user.reload.upvotes_count.should == 0
          @gnu2.global_node.reload.upvotes_count.should == 0
          @gnu2.node.reload.upvotes_count.should == 0
        end
      end
  
      context 'when another user has the link in another global' do
        before do
          @glu2 = GlobalLinkUser.create(:user=>@user_two, :global => @global2, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        end
        it 'should destroy 0 node' do
          expect {
            @gnu1.destroy
          }.to change(Node, :count).by(0)
        end
        it 'should destroy 1 globals_nodes' do
          expect {
            @gnu1.destroy
          }.to change(GlobalNode, :count).by(-1)
        end
        it 'should destroy 1 globals_nodes_users' do
          expect {
            @gnu1.destroy
          }.to change(GlobalNodeUser, :count).by(-1)
        end
        it 'should destroy 1 nodes_users' do
          expect {
            @gnu1.destroy
          }.to change(NodeUser, :count).by(-1)
        end
  
        it 'should destroy 0 link' do
          expect {
            @gnu1.destroy
          }.to change(Link, :count).by(0)
        end
  
        it 'should destroy 1 glu' do
          expect {
            @gnu1.destroy
          }.to change(GlobalLinkUser, :count).by(-1)
        end
  
        it 'should destroy 1 gl' do
          expect {
            @gnu1.destroy
          }.to change(GlobalLink, :count).by(-1)
        end
  
        it 'should destroy 1 lu' do
          expect {
            @gnu1.destroy
          }.to change(LinkUser, :count).by(-1)
        end
  
        it 'update the caches' do
          @gnu2.reload.upvotes_count.should == 1
          @gnu2.node_user.reload.upvotes_count.should == 1
          @gnu2.global_node.reload.upvotes_count.should == 1
          @gnu2.node.reload.upvotes_count.should == 2
          @gnu1.destroy
          @gnu2.reload.upvotes_count.should == 0 
          @gnu2.node_user.reload.upvotes_count.should == 0
          @gnu2.global_node.reload.upvotes_count.should == 0
          @gnu2.node.reload.upvotes_count.should == 1
        end
      end
  
      context 'when the user has the link in another global' do
        before do
          @glu2 = GlobalLinkUser.create(:user=>@user, :global => @global2, :node_from_id => @gnu1.node.id, :node_to_id => @gnu2.node.id, :value => 1)
        end
        it 'should destroy 0 node' do
          expect {
            @gnu1.destroy
          }.to change(Node, :count).by(0)
        end
        it 'should destroy 1 globals_nodes' do
          expect {
            @gnu1.destroy
          }.to change(GlobalNode, :count).by(-1)
        end
        it 'should destroy 1 globals_nodes_users' do
          expect {
            @gnu1.destroy
          }.to change(GlobalNodeUser, :count).by(-1)
        end
        it 'should destroy 0 nodes_users' do
          expect {
            @gnu1.destroy
          }.to change(NodeUser, :count).by(0)
        end
  
        it 'should destroy 0 link' do
          expect {
            @gnu1.destroy
          }.to change(Link, :count).by(0)
        end
  
        it 'should destroy 1 glu' do
          expect {
            @gnu1.destroy
          }.to change(GlobalLinkUser, :count).by(-1)
        end
  
        it 'should destroy 1 gl' do
          expect {
            @gnu1.destroy
          }.to change(GlobalLink, :count).by(-1)
        end
  
        it 'should destroy 0 lu' do
          expect {
            @gnu1.destroy
          }.to change(LinkUser, :count).by(0)
        end
  
        it 'update the caches' do
          @gnu2.reload.upvotes_count.should == 1
          @gnu2.node_user.reload.upvotes_count.should == 1
          @gnu2.global_node.reload.upvotes_count.should == 1
          @gnu2.node.reload.upvotes_count.should == 1
          @gnu1.destroy
          @gnu2.reload.upvotes_count.should == 0 
          @gnu2.node_user.reload.upvotes_count.should == 1
          @gnu2.global_node.reload.upvotes_count.should == 0
          @gnu2.node.reload.upvotes_count.should == 1
        end
      end

      context 'when the user has another link in this global where the links share a node from' do
        before do
          @glu2 = GlobalLinkUser.create(:user=>@user, :global => @global, :node_from_id => @gnu1.node.id, :node_to_id => @gnu3.node.id, :value => 1)
        end
        it 'should destroy 1 node (despite shared node from -- all on user)' do
          expect {
            @gnu1.destroy
          }.to change(Node, :count).by(-1)
        end
        it 'should destroy 1 globals_nodes' do
          expect {
            @gnu1.destroy
          }.to change(GlobalNode, :count).by(-1)
        end
        it 'should destroy 1 globals_nodes_users' do
          expect {
            @gnu1.destroy
          }.to change(GlobalNodeUser, :count).by(-1)
        end
        it 'should destroy 1 nodes_users' do
          expect {
            @gnu1.destroy
          }.to change(NodeUser, :count).by(-1)
        end
  
        it 'should destroy 1 link' do
          expect {
            @gnu1.destroy
          }.to change(Link, :count).by(-2)
        end
  
        it 'should destroy 1 glu' do
          expect {
            @gnu1.destroy
          }.to change(GlobalLinkUser, :count).by(-2)
        end
  
        it 'should destroy 1 glu' do
          expect {
            @gnu1.destroy
          }.to change(GlobalLink, :count).by(-2)
        end
  
        it 'should destroy 1 glu' do
          expect {
            @gnu1.destroy
          }.to change(LinkUser, :count).by(-2)
        end
  
        it 'update the caches' do
          @gnu2.reload.upvotes_count.should == 1
          @gnu2.node_user.reload.upvotes_count.should == 1
          @gnu2.global_node.reload.upvotes_count.should == 1
          @gnu2.node.reload.upvotes_count.should == 1
          @gnu3.reload.upvotes_count.should == 1
          @gnu3.node_user.reload.upvotes_count.should == 1
          @gnu3.global_node.reload.upvotes_count.should == 1
          @gnu3.node.reload.upvotes_count.should == 1
          @gnu1.destroy
          @gnu2.reload.upvotes_count.should == 0 
          @gnu2.node_user.reload.upvotes_count.should == 0
          @gnu2.global_node.reload.upvotes_count.should == 0
          @gnu2.node.reload.upvotes_count.should == 0
          @gnu3.reload.upvotes_count.should == 0 
          @gnu3.node_user.reload.upvotes_count.should == 0
          @gnu3.global_node.reload.upvotes_count.should == 0
          @gnu3.node.reload.upvotes_count.should == 0
        end
      end
    end
  end
end
