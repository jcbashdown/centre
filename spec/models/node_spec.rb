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
      end
      it 'should create one link' do
        @node.links.count.should == 1
      end
    end
  end
end
