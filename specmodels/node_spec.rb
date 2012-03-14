require 'spec_helper'

describe Node do
  describe 'construct from node links' do
    before do
      @global = Factory(:global)
      @node = Factory(:node, :title=>'c title')
      @node_two = Factory(:node, :title=>'x title')
      @node_three = Factory(:node, :title=>'b title')
      @nodes_global1 = Factory(:nodes_global, :node=>@node, :global=>@global)
      @nodes_global2 = Factory(:nodes_global, :node=>@node_two, :global=>@global)
      @nodes_global3 = Factory(:nodes_global, :node=>@node_three, :global=>@global)
      @link1 = Link.new(:nodes_global_from=>@nodes_global1, :nodes_global_to=> @nodes_global2, :node_from=>@node, :node_to=>@node_two)
      @link2 = Link.new(:nodes_global_from=>@nodes_global1, :nodes_global_to=> @nodes_global3, :node_from=>@node, :node_to=>@node_three)
      @link3 = Link.new(:nodes_global_from=>@nodes_global1, :nodes_global_to=> @nodes_global2, :node_from=>@node, :node_to=>@node_two)
      @link4 = Link.new(:nodes_global_from=>@nodes_global3, :nodes_global_to=> @nodes_global2, :node_from=>@node_three, :node_to=>@node_two)
      @from_node_links = [@link2,
                          @link1]
      @to_node_two_links = [@link4,
                            @link3]
    end
    it 'should return the correct links array in alphabetical order' do
      @nodes_global1.construct_from_node_links.inspect.should == @from_node_links.inspect
    end
    it 'should return the correct links array in alphabetical order' do
      @nodes_global2.construct_to_node_links.inspect.should == @to_node_two_links.inspect
    end
  end
  before do
    @node = Node.new
  end
  context 'when a node has no title' do
    it 'should not be valid' do
      @node.should_not be_valid
    end
  end

  context 'when a node has no text' do
    before do
     @node.title = "title"
     @node.save! 
    end
    it 'should be valid' do
      @node.should be_valid
    end
  end
  context 'creating links' do
    before do
      @node.title = "node_one"
      @node.save!
      @node_two = Factory(:node)
    end
    context 'linking node to node_two' do
      before do
        @global = Factory(:global)
        @user = Factory(:user)
        @node = Factory(:node, :title=>'c title')
        @node_two = Factory(:node, :title=>'x title')
        @node_three = Factory(:node, :title=>'b title')
        @nodes_global1 = Factory(:nodes_global, :node=>@node, :global=>@global)
        @nodes_global2 = Factory(:nodes_global, :node=>@node_two, :global=>@global)
        @nodes_global3 = Factory(:nodes_global, :node=>@node_three, :global=>@global)
        @link_to = Link.new(:value=>1,:nodes_global_from=>@nodes_global1, :nodes_global_to=> @nodes_global2, :node_from=>@node, :node_to=>@node_two)
        @link_to.users << @user
        @link_to.save!
        @link_to.reload
        @node.reload
        @node_two.reload
      end
      context 'sum votes for upvotes' do
        before do
          @vote_type = 1
        end
        it 'should return 1 for node two' do
          @node_two.sum_votes(@vote_type).should == 1
        end
      end
      it 'should create one link out' do
        @node.link_tos.count.should == 1
      end
      it 'should create one target node' do
        @node.node_tos.count.should == 1
      end
      it 'should create one source node' do
        @node_two.node_froms.count.should == 1
      end
      it 'should create one link in' do
        @node_two.link_ins.count.should == 1
      end
      it "should increment upvotes for node two" do
        @node_two.upvotes_count.should == 1
      end
      it 'should not be ignored' do
        @node.ignore.should == false
        @node_two.ignore.should == false
        @node.has_links?.should == true
        @node_two.has_links?.should == true
      end
    end
  end
end
