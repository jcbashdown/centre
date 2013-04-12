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
                                       :node_count => 100,
                                       :link_count_per_node => 100
                                      }, true)}
      let(:context_node) {link_map.nodes.last}
      let(:existing) {Node::GlobalNode.where(title:new_text)[0]}
      let(:to_be_related_links_global) {Link::GlobalLink.where('global_node_from_id = ? || global_node_to_id = ?', existing.try(:id), existing.try(:id))}
      let(:to_be_related_links_group) {Link::GroupLink.where(:group_id => context_node.user.groups.map(&:id)).where('global_node_from_id = ? || global_node_to_id = ?', existing.try(:id), existing.try(:id))}
      before(:all){link_map}
      after(:all){Link.delete_all;Question.delete_all;User.delete_all;Group.delete_all;Node.delete_all}
      it "should be quicker" do
        start = Time.now
        context_node.update_title new_text
        p Time.now - start
      end
    end
  end
end
