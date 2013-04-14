require 'spec_helper'
require 'random_link_map'
require 'models/context_node_spec_helper'
#remove active, just find active as needed and keep counts, set counts on create, update on user link save (include destroy)
describe ContextNode do
  describe ".update_text" do
    let(:new_text) {'Some revised title'}
    context "when there are many many links and nodes and such" do
      let(:link_map) {RandomLinkMap.new( {
                                       :question_count => 5,
                                       :user_count => 5,
                                       :group_count => 5,
                                       :node_count => 25,
                                       :link_count_per_node => 25
                                      }, true)}
      let(:context_node) {ContextNode.find(link_map.nodes.last)}
      #before {p "before";link_map; p "after"}
      #5.times do
      #  it "should be quicker" do
      #    start = Time.now
      #    p Link::UserLink.count
      #    p Link::UserLink.where(user_id:context_node.user_id).count
      #    p ContextNode.count
      #    p ContextNode.where(user_id:context_node.user_id).count
      #    context_node.update_title new_text
      #    p Time.now - start
      #  end
      #end
    end
  end
end
