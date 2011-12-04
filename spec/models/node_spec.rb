require 'spec_helper'

describe Node do
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
  context 'creating links with other nodes' do
    context 'when a node has no nodes' do
      before do
       @node.title = "title"
       @node.save! 
      end
      it 'should be valid' do
        @node.should be_valid
      end
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
        @node.target_nodes << @node_two
        @link_in = @node.link_tos.first
        @hash = [{:node => @node_two, :link_in=>@link_in, :link_to=>nil}]
        @link_to = @node_two.link_ins.first
        @hash_two = [{:node => @node, :link_in=>nil, :link_to=>@link_to}]
      end
      it 'should create one link out' do
        @node.link_tos.count.should == 1
      end
      it 'should return the correct array when all_with_link_ids called on node' do
        @node.all_with_link_ids.should == @hash
      end
      it 'should return the correct array when all_with_link_ids called on node two' do
        @node_two.all_with_link_ids.should == @hash_two
      end
      it 'should create one target node' do
        @node.target_nodes.count.should == 1
      end
      it 'should create one source node' do
        @node_two.source_nodes.count.should == 1
      end
      it 'should create one link in' do
        @node_two.link_ins.count.should == 1
      end
    end
  end
end
