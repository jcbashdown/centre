require 'spec_helper'

describe Node do
  describe 'construct from node links' do
    before do
      @node = Factory(:node, :title=>'c title')
      @node_two = Factory(:node, :title=>'x title')
      @node_three = Factory(:node, :title=>'b title')
      @link1 = Link.new(:node_from=>@node, :node_to=>@node_two)
      @link2 = Link.new(:node_from=>@node, :node_to=>@node_three)
      @link3 = Link.new(:node_from=>@node, :node_to=>@node_two)
      @link4 = Link.new(:node_from=>@node_three, :node_to=>@node_two)
      @from_node_links = [@link2,
                          @link1]
      @to_node_two_links = [@link4,
                            @link3]
    end
    it 'should return the correct links array in alphabetical order' do
      @node.construct_from_node_links.inspect.should == @from_node_links.inspect
    end
    it 'should return the correct links array in alphabetical order' do
      @node_two.construct_to_node_links.inspect.should == @to_node_two_links.inspect
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
        @user = Factory(:user)
        @node.node_tos << @node_two
        @link_to = @node.link_tos.first
        @link_to.value = 1
        @link_to.users << @user
        @link_to.save!
        @link_to.reload
        @node.reload
        @node_two.reload
        # only count votes if user?
        # require value for link
        # count ignore only when value
        # count ignore on save
        # increment caches on save
        link_in = Link.new(:node_from=>@node_two, :node_to=>@node)
        @hash = [{:node => @node_two, :link_in=>link_in, :link_to=>@link_to}]
        @link_in = @node_two.link_ins.first
        link_to = Link.new(:node_from=>@node_two, :node_to=>@node)
        @hash_two = [{:node => @node, :link_in=>@link_in, :link_to=>link_to}]
        @link_to.should == @link_in
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
      it 'should return the correct array when all_with_link_ids called on node' do
        @node.all_with_link_ids.to_s.should == @hash.to_s
      end
      it 'should return the correct array when all_with_link_ids called on node two' do
        @node_two.all_with_link_ids.to_s.should == @hash_two.to_s
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
