require 'spec_helper'

describe GlobalsLink do
  describe "validations" do
    it "should limit to one for each user link combination" do
      pending
    end
  end
  
  describe "update node to xml" do
    before do
      @user = Factory(:user)
      @global = Factory(:global)
      @node1 = Factory(:node, :title=>'node one')
      p @node1.globals
      p @node1.nodes_globals
      @node2 = Factory(:node, :title=>'node two')
      @node3 = Factory(:node, :title=>'node three')
      @node4 = Factory(:node, :title=>'node four')
      @node5 = Factory(:node, :title=>'node five')
      @node6 = Factory(:node, :title=>'node six')
      @link1 = Link.create(:node_from=>@node2,:value=>1,:node_to=>@node1)
      p 999
      @link1.globals << @global
      p 999
      @link2 = Link.create(:node_from=>@node3,:value=>-1,:node_to=>@node1)
      @link2.globals << @global
      @link3 = Link.create(:node_from=>@node4,:value=>1,:node_to=>@node1)
      @link3.globals << @global
      @link4 = Link.create(:node_from=>@node5,:value=>1,:node_to=>@node2)
      @link4.globals << @global
    end
    it 'should create and save the correct xml' do
      @node1.votes_xml.should == "123"
    end

  end
end
