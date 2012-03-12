require 'spec_helper'

describe NodesGlobal do
  context 'creating links' do
    before do
      @global = Factory(:global)
      @node_one = Factory(:node, :title=>'title')
      @node_two = Factory(:node, :title=>'title two')
      @nodes_global1 = Factory(:nodes_global, :node=>@node_one, :global=>@global)
      @nodes_global2 = Factory(:nodes_global, :node=>@node_two, :global=>@global)
    end
    context 'linking node to node_two' do
      before do
        @user = Factory(:user)
        @nodes_global1.nodes_global_tos << @nodes_global2
        @link_to = @nodes_global1.link_tos.first
        @link_to.globals << @global
        @link_to.value = 1
        @link_to.users << @user
        @link_to.save!
        @globals_link = GlobalsLink.where(:global_id=>@global.id, :link_id=>@link_to.id).first
        #why is the following not incrementing counter cache and therefore saving - creation of user globals link should do this. is a alphabet thing? 
        count = UserGlobalsLink.count
        @globals_link.users << @user
        UserGlobalsLink.count.should == count+1
        #still not working without this even with after create save call back on user global link
        #@globals_link.save!
        @link_to.reload
        @nodes_global1.reload
        @nodes_global2.reload
      end
      context 'sum votes for upvotes' do
        before do
          @vote_type = 1
        end
        it 'should return 1 for node two' do
          @nodes_global2.sum_votes(@vote_type).should == 1
        end
      end
      it 'should increment the users count' do
        @globals_link.users_count.should == 1
      end
      it 'should create one link out' do
        @nodes_global1.link_tos.count.should == 1
      end
      it 'should create one target node' do
        @nodes_global1.nodes_global_tos.count.should == 1
      end
      it 'should create one source node' do
        @nodes_global2.nodes_global_froms.count.should == 1
      end
      it 'should create one link in' do
        @nodes_global2.link_ins.count.should == 1
      end
      it "should increment upvotes for node two" do
        @nodes_global2.upvotes_count.should == 1
      end
      it 'should not be ignored' do
        @nodes_global1.ignore.should == false
        @nodes_global2.ignore.should == false
        @nodes_global1.has_links?.should == true
        @nodes_global2.has_links?.should == true
      end
    end
  end
end
