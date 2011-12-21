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
        @link_to = @node.link_tos.first
        link_in = Link.new(:node_from=>@node_two.id, :node_to=>@node.id)
        @hash = [{:node => @node_two, :link_in=>link_in, :link_to=>@link_to}]
        @link_in = @node_two.link_ins.first
        link_to = Link.new(:node_from=>@node_two.id, :node_to=>@node.id)
        @hash_two = [{:node => @node, :link_in=>@link_in, :link_to=>link_to}]
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
  #context 'creating links through update attributes when value is nil' do
  #  before do
  #    @node = Factory(:node)
  #    @params =  {"link_tos_attributes"=>[{"node_from"=>@node.id, "value"=>"nil", "node_to"=>5}]}
  #  end
    
  #  it "should set value to nil" do
  #    @node.update_attributes @params
  #    @node.link_tos.first.value.should == nil
  #  end
  #end
end
