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
    it 'should be valid' do

    end
  end
  context 'creating links with other nodes' do
    context 'when a node has no nodes' do
      it 'should be valid' do
        
      end
    end
  end
end
