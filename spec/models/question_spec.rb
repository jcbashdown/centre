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
      before do
        @link1 = Link::UserLink::PositiveUserLink.create(:user=>user, :question => question, :global_node_to_id => context_node.global_node_id, :global_node_from_id => context_node2.global_node_id)
        @link2 = Link::UserLink::PositiveUserLink.create(:user=>user, :question => question, :global_node_to_id => context_node.global_node_id, :global_node_from_id => context_node3.global_node_id)
        @link3 = Link::UserLink::PositiveUserLink.create(:user=>user, :question => question, :global_node_to_id => context_node3.global_node_id, :global_node_from_id => context_node4.global_node_id)
        ContextNode.reindex
      end
      context "when set up" do
        let(:argument) {
          [
            {
              for: [
                {
                  for: [],
                  against: []
                }.merge(context_node2.global_node.reload.attributes),
                {
                  for: [],
                  against: []
                }.merge(context_node3.global_node.reload.attributes),
              ],
              against: [],
            }.merge(context_node.global_node.reload.attributes),
            {
              for: [],
              against: []
            }.merge(context_node2.global_node.reload.attributes)
          ]
        }
        let(:sub_argument) {
          {
            for: [
              {
                for: [],
                against: []
              }.merge(context_node4.global_node.reload.attributes)
            ],
            against: []
          }.merge(context_node3.global_node.reload.attributes)
        }

        it "returns the correct argument" do
          question.argument.should == argument
        end

        it "returns the correct sub argument when required" do
          context_node3.global_node.reload.argument_attributes(question).should == sub_argument
        end

      end
    end
  end

end
