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
                                       :node_count => 10,
                                       :link_count_per_node => 20
                                      }, true)}
      let(:context_node) {link_map.nodes.last}
      let(:existing) {Node::GlobalNode.where(title:new_text)[0]}
      let(:to_be_related_links_global) {Link::GlobalLink.where('global_node_from_id = ? || global_node_to_id = ?', existing.try(:id), existing.try(:id))}
      let(:to_be_related_links_group) {Link::GroupLink.where(:group_id => context_node.user.groups.map(&:id)).where('global_node_from_id = ? || global_node_to_id = ?', existing.try(:id), existing.try(:id))}
      before(:all){link_map}
      after(:all){Link.delete_all;Question.delete_all;User.delete_all;Group.delete_all;Node.delete_all}

      [:group].each do |link_type|
        it "should ensure the correct #{link_type}_links have been destroyed and the correct #{link_type}_links have been updated" do
          links = context_node.send(:"#{link_type}_links")
          to_be_related_links = send(:"to_be_related_links_#{link_type}")
          destroyed = []
          updated_minus_one = []
          links.each do |link|
            if (to_be_related_links - [link]).count == to_be_related_links.count#if the link isn't one of the links we're finding/creating and relating
              if link.reload.users_count == 1
                #binding.pry
                p "adding"
                p link.users_count
                p link.user_links.count
                p "id"
                p link.id
                destroyed << link
              elsif link.reload.users_count > 1
                updated_minus_one << link
              end
            end
          end
          context_node.update_title(new_text)
          to_be_related_links.each do |link|
            (link.users_count + 1).should == link.reload.users_count
          end
          updated_minus_one.each do |link|
            (link.users_count - 1).should == link.reload.users_count
          end
          destroyed.each do |link|
            #recreating with same id?
            params = {global_node_from_id: link.global_node_from_id, global_node_to_id: link.global_node_to_id}
            params.merge!(group_id: link.group_id) if link_type == :group
            #link_count = Link.send(:"#{link_type}_link").where(params).count
            #binding.pry if link_count != 0
                p "testing"
                p link.users_count
                p link.user_links.count
                p "id"
                p link.id
            Link.send(:"#{link_type}_link").where(params).count.should == 0
          end
        end
      end
      #it_should_behave_like "a context_node correctly updating node text"
    end
  end
end
