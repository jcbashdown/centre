require 'spec_helper'

describe Question do
  describe ".argument" do
    context "integration" do
      let(:user) {FactoryGirl.create(:user)}
      let(:question) {FactoryGirl.create(:question)}
      let(:context_node) {Node::UserNode.create(:user=>user, :question=>question, :title => 'Title', :is_conclusion => true)}
      let(:context_node2) {Node::UserNode.create(:user=>user, :question=>question, :title => 'Title2', :is_conclusion => true)}
      let(:context_node3) {Node::UserNode.create(:user=>user, :question=>question, :title => 'Title3', :is_conclusion => false)}
      let(:context_node4) {Node::UserNode.create(:user=>user, :question=>question, :title => 'Title4', :is_conclusion => false)}
      let(:guids) {(1..4).map {|item| SimpleUUID::UUID.new}}
      before do
        guids
        @link1 = Link::UserLink::PositiveUserLink.create(:user=>user, :question => question, :global_node_to_id => context_node.global_node_id, :global_node_from_id => context_node2.global_node_id)
        @link2 = Link::UserLink::PositiveUserLink.create(:user=>user, :question => question, :global_node_to_id => context_node.global_node_id, :global_node_from_id => context_node3.global_node_id)
        @link3 = Link::UserLink::PositiveUserLink.create(:user=>user, :question => question, :global_node_to_id => context_node3.global_node_id, :global_node_from_id => context_node4.global_node_id)
        ContextNode.reindex
        SimpleUUID::UUID.stub(:new).and_return(guids[0], guids[1], guids[2], guids[3])
      end
      context "when set up" do
        let(:argument) {
          [
            {
              guid: guids[0].to_guid,
              parent: nil,
              for: [
                {
                  guid: guids[1].to_guid,
                  parent: guids[0].to_guid,
                  for: [],
                  against: []
                }.merge(context_node2.global_node.reload.attributes),
                {
                  guid: guids[2].to_guid,
                  parent: guids[0].to_guid,
                  for: [],
                  against: []
                }.merge(context_node3.global_node.reload.attributes),
              ],
              against: [],
            }.merge(context_node.global_node.reload.attributes),
            {
              guid: guids[3].to_guid,
              parent: nil,
              for: [],
              against: []
            }.merge(context_node2.global_node.reload.attributes)
          ]
        }
        let(:sub_argument) {
          {
            guid: guids[0].to_guid,
            parent: nil,
            for: [
              {
                guid: guids[1].to_guid,
                parent: guids[0].to_guid,
                for: [],
                against: []
              }.merge(context_node4.global_node.reload.attributes)
            ],
            against: []
          }.merge(context_node3.global_node.reload.attributes)
        }
        let(:sub_argument2) {
          {
            guid: guids[0].to_guid,
            parent: nil,
            for: [
              {
                guid: guids[1].to_guid,
                parent: guids[0].to_guid,
                for: [],
                against: []
              }.merge(context_node2.global_node.reload.attributes),
              {
                guid: guids[2].to_guid,
                parent: guids[0].to_guid,
                for: [
                  {
                    guid: guids[3].to_guid,
                    parent: guids[0].to_guid.to_s+guids[2].to_guid.to_s,
                    for: [],
                    against: []
                  }.merge(context_node4.global_node.reload.attributes)
                ],
                against: []
              }.merge(context_node3.global_node.reload.attributes)
            ],
            against: [],
          }.merge(context_node.global_node.reload.attributes)
        }

        it "returns the correct argument" do
          question.argument.should == argument
        end

        it "returns the correct argument at depth" do
          context_node.global_node.reload.argument_attributes({question:question}, nil, {limit:2,current:0}).should == sub_argument2
        end

        it "returns the correct sub argument when required" do
          context_node3.global_node.reload.argument_attributes({question:question}).should == sub_argument
        end

      end
    end
  end

end
