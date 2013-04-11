require 'spec_helper'
require 'random_link_map'
require 'models/context_node_spec_helper'

describe ContextNode do
  describe ".update_text" do
    let(:new_text) {'Some revised title'}
    context "when there are many many links and nodes and such" do
      let(:link_map) {RandomLinkMap.new( {
                                       :question_count => 5,
                                       :user_count => 5,
                                       :group_count => 5,
                                       :node_count => 5,
                                       :link_count_per_node => 5
                                      }, true)}
      let(:context_node) {link_map.nodes.last}
      before {link_map}
      it_should_behave_like "a context_node correctly updating node text"
    end
  end
end
