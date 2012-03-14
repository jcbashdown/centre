require 'spec_helper'

describe GlobalsLink do
  describe "validations" do
    it "should limit to one for each user link combination" do
      pending
    end
  end
  
  describe "update node to xml" do
    before do
      @global = Factory(:global)
      @node1 = Factory(:node, :title=>'node one')
      @nodes_global1 = Factory(:nodes_global, :node=>@node1, :global=>@global)
      @node2 = Factory(:node, :title=>'node two')
      @nodes_global2 = Factory(:nodes_global, :node=>@node2, :global=>@global)
      @node3 = Factory(:node, :title=>'node three')
      @nodes_global3 = Factory(:nodes_global, :node=>@node3, :global=>@global)
      @node4 = Factory(:node, :title=>'node four')
      @nodes_global4 = Factory(:nodes_global, :node=>@node4, :global=>@global)
      @node5 = Factory(:node, :title=>'node five')
      @nodes_global5 = Factory(:nodes_global, :node=>@node5, :global=>@global)
      @node6 = Factory(:node, :title=>'node six')
      @nodes_global6 = Factory(:nodes_global, :node=>@node6, :global=>@global)
      @link1 = Link.create(:nodes_global_from=>@nodes_global2,:value=>1,:nodes_global_to=>@nodes_global1)
      @link1.globals << @global
      @link2 = Link.create(:nodes_global_from=>@nodes_global3,:value=>-1,:nodes_global_to=>@nodes_global1)
      @link2.globals << @global
      @link3 = Link.create(:nodes_global_from=>@nodes_global4,:value=>1,:nodes_global_to=>@nodes_global1)
      @link3.globals << @global
      @link4 = Link.create(:nodes_global_from=>@nodes_global5,:value=>1,:nodes_global_to=>@nodes_global2)
      @link4.globals << @global
    end
    it 'should create and save the correct xml' do
      pending
      #global_link = GlobalsLink.where(:global_id=>@global.id, :link_id=>@link1.id).first
      #global_link.save!
      #NodesGlobal.where(:node_id=>@node1.id, :global_id=>@global.id).first.votes_xml.should match /#{node_xml}/
      #NodesGlobal.where(:node_id=>@node1.id, :global_id=>@global.id).first.votes_xml.should == node_xml
    end
    
    def node_xml     
      node_xml = %Q|<node>
  <id type="integer">#{@node1.id}</id>
  <title>node one</title>
  <text>Test text</text>
  <created-at type="datetime">.*</created-at>
  <updated-at type="datetime">.*</updated-at>
  <user-id type="integer" nil="true"/>
  <upvotes-count type="integer">0</upvotes-count>
  <downvotes-count type="integer">0</downvotes-count>
  <equivalents-count type="integer">0</equivalents-count>
  <ignore type="boolean">false</ignore>
  <page-rank type="float">0.0</page-rank>
  <node_froms type="array">
    <node>
      <id type="integer">#{@node2.id}</id>
      <title>node two</title>
      <text>Test text</text>
      <created-at type="datetime">.*</created-at>
      <updated-at type="datetime">.*</updated-at>
      <user-id type="integer" nil="true"/>
      <upvotes-count type="integer">0</upvotes-count>
      <downvotes-count type="integer">0</downvotes-count>
      <equivalents-count type="integer">0</equivalents-count>
      <ignore type="boolean">false</ignore>
      <page-rank type="float">0.0</page-rank>
      <node_froms type="array">
        <node>
          <id type="integer">#{@node5.id}</id>
          <title>node five</title>
          <text>Test text</text>
          <created-at type="datetime">.*</created-at>
          <updated-at type="datetime">.*</updated-at>
          <user-id type="integer" nil="true"/>
          <upvotes-count type="integer">0</upvotes-count>
          <downvotes-count type="integer">0</downvotes-count>
          <equivalents-count type="integer">0</equivalents-count>
          <ignore type="boolean">true</ignore>
          <page-rank type="float">0.0</page-rank>
        </node>
      </node_froms>
    </node>
        <node>
      <id type="integer">#{@node3.id}</id>
      <title>node three</title>
      <text>Test text</text>
      <created-at type="datetime">.*</created-at>
      <updated-at type="datetime">.*</updated-at>
      <user-id type="integer" nil="true"/>
      <upvotes-count type="integer">0</upvotes-count>
      <downvotes-count type="integer">0</downvotes-count>
      <equivalents-count type="integer">0</equivalents-count>
      <ignore type="boolean">true</ignore>
      <page-rank type="float">0.0</page-rank>
    </node>
        <node>
      <id type="integer">#{@node4.id}</id>
      <title>node four</title>
      <text>Test text</text>
      <created-at type="datetime">.*</created-at>
      <updated-at type="datetime">.*</updated-at>
      <user-id type="integer" nil="true"/>
      <upvotes-count type="integer">0</upvotes-count>
      <downvotes-count type="integer">0</downvotes-count>
      <equivalents-count type="integer">0</equivalents-count>
      <ignore type="boolean">true</ignore>
      <page-rank type="float">0.0</page-rank>
    </node>
  </node_froms>
</node>|
    end

  end
  describe "update node to xml different links" do
    before do
      @global = Factory(:global)
      @node1 = Factory(:node, :title=>'node one')
      @nodes_global1 = Factory(:nodes_global, :node=>@node1, :global=>@global)
      @node2 = Factory(:node, :title=>'node two')
      @nodes_global2 = Factory(:nodes_global, :node=>@node2, :global=>@global)
      @node3 = Factory(:node, :title=>'node three')
      @nodes_global3 = Factory(:nodes_global, :node=>@node3, :global=>@global)
      @node4 = Factory(:node, :title=>'node four')
      @nodes_global4 = Factory(:nodes_global, :node=>@node4, :global=>@global)
      @node5 = Factory(:node, :title=>'node five')
      @nodes_global5 = Factory(:nodes_global, :node=>@node5, :global=>@global)
      @node6 = Factory(:node, :title=>'node six')
      @nodes_global6 = Factory(:nodes_global, :node=>@node6, :global=>@global)
      @link1 = Link.create(:nodes_global_from=>@nodes_global2,:value=>1,:nodes_global_to=>@nodes_global1)
      @link1.globals << @global
      @link2 = Link.create(:nodes_global_from=>@nodes_global3,:value=>-1,:nodes_global_to=>@nodes_global1)
      @link2.globals << @global
      @link3 = Link.create(:nodes_global_from=>@nodes_global4,:value=>1,:nodes_global_to=>@nodes_global1)
      @link3.globals << @global
      @link4 = Link.create(:nodes_global_from=>@nodes_global5,:value=>1,:nodes_global_to=>@nodes_global2)
      @link4.globals << @global
      @link5 = Link.create(:nodes_global_from=>@nodes_global6,:value=>1,:nodes_global_to=>@nodes_global1)
      @link5.globals << @global
    end
    it 'should create and save the correct xml with more links' do
      pending
      #NodesGlobal.where(:node_id=>@node1.id, :global_id=>@global.id).first.votes_xml.should match /#{node_xml_two}/
      #NodesGlobal.where(:node_id=>@node1.id, :global_id=>@global.id).first.votes_xml.should == node_xml_two
    end
    
    def node_xml_two
      node_xml = %Q|<node>
  <id type="integer">#{@node1.id}</id>
  <title>node one</title>
  <text>Test text</text>
  <created-at type="datetime">.*</created-at>
  <updated-at type="datetime">.*</updated-at>
  <user-id type="integer" nil="true"/>
  <upvotes-count type="integer">0</upvotes-count>
  <downvotes-count type="integer">0</downvotes-count>
  <equivalents-count type="integer">0</equivalents-count>
  <ignore type="boolean">false</ignore>
  <page-rank type="float">0.0</page-rank>
  <node_froms type="array">
    <node>
      <id type="integer">#{@node2.id}</id>
      <title>node two</title>
      <text>Test text</text>
      <created-at type="datetime">.*</created-at>
      <updated-at type="datetime">.*</updated-at>
      <user-id type="integer" nil="true"/>
      <upvotes-count type="integer">0</upvotes-count>
      <downvotes-count type="integer">0</downvotes-count>
      <equivalents-count type="integer">0</equivalents-count>
      <ignore type="boolean">false</ignore>
      <page-rank type="float">0.0</page-rank>
      <node_froms type="array">
        <node>
          <id type="integer">#{@node5.id}</id>
          <title>node five</title>
          <text>Test text</text>
          <created-at type="datetime">.*</created-at>
          <updated-at type="datetime">.*</updated-at>
          <user-id type="integer" nil="true"/>
          <upvotes-count type="integer">0</upvotes-count>
          <downvotes-count type="integer">0</downvotes-count>
          <equivalents-count type="integer">0</equivalents-count>
          <ignore type="boolean">true</ignore>
          <page-rank type="float">0.0</page-rank>
        </node>
      </node_froms>
    </node>
        <node>
      <id type="integer">#{@node3.id}</id>
      <title>node three</title>
      <text>Test text</text>
      <created-at type="datetime">.*</created-at>
      <updated-at type="datetime">.*</updated-at>
      <user-id type="integer" nil="true"/>
      <upvotes-count type="integer">0</upvotes-count>
      <downvotes-count type="integer">0</downvotes-count>
      <equivalents-count type="integer">0</equivalents-count>
      <ignore type="boolean">true</ignore>
      <page-rank type="float">0.0</page-rank>
    </node>
        <node>
      <id type="integer">#{@node4.id}</id>
      <title>node four</title>
      <text>Test text</text>
      <created-at type="datetime">.*</created-at>
      <updated-at type="datetime">.*</updated-at>
      <user-id type="integer" nil="true"/>
      <upvotes-count type="integer">0</upvotes-count>
      <downvotes-count type="integer">0</downvotes-count>
      <equivalents-count type="integer">0</equivalents-count>
      <ignore type="boolean">true</ignore>
      <page-rank type="float">0.0</page-rank>
    </node>
        <node>
      <id type="integer">#{@node6.id}</id>
      <title>node six</title>
      <text>Test text</text>
      <created-at type="datetime">.*</created-at>
      <updated-at type="datetime">.*</updated-at>
      <user-id type="integer" nil="true"/>
      <upvotes-count type="integer">0</upvotes-count>
      <downvotes-count type="integer">0</downvotes-count>
      <equivalents-count type="integer">0</equivalents-count>
      <ignore type="boolean">true</ignore>
      <page-rank type="float">0.0</page-rank>
    </node>
  </node_froms>
</node>|
    end
  end
  describe 'users count' do
    before do
      @user = Factory(:user)
      @global = Factory(:global)
      @node1 = Factory(:node, :title=>'node one')
      @node1.globals << @global
      @node2 = Factory(:node, :title=>'node two')
      @node2.globals << @global
      @link1 = Link.create(:node_from=>@node2,:value=>1,:node_to=>@node1)
      @link1.globals << @global
      @globals_link = GlobalsLink.where(:global_id=>@global.id, :link_id=>@link1.id).first
      @globals_link.users << @user
    end
    it 'should count the user' do
      pending
      #@globals_link.users_count.should == 1
    end
    it 'should include the users in user link users array' do
      pending
      #@globals_link.users.should include(@user)

    end
  end

end
