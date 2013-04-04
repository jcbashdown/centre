shared_examples_for 'updating node text' do
  context "correct links changes" do
    it "should not cause a change in the link count for this user" do
      expect {
        context_node.update_text(new_text)
      }.to change(user.links, :count).by 0
    end
    it "should ensure all for all previous links related to the context_node.global_node there are new links related to the new context_node.global_node" do
      old_attributes = context_node.user_links.inject([]) do |old_attributes, link|
        attributes_hash = {}
        attributes_hash[:global_node_to_id] = link.global_node_to_id unless link.global_node_to_id == context_node.global_node_id
        attributes_hash[:global_node_from_id] = link.global_node_from_id unless link.global_node_from_id == context_node.global_node_id
        attributes_hash[:type] = link.type
        old_attributes << attributes_hash
        old_attributes
      end
      new_context_node = context_node.update_text(new_text)
      old_attributes.each do |old_attribute_hash|
        if old_attribute_hash[:global_node_from_id]
          Link::UserLink.where(old_attribute_hash.merge(user:user,global_node_to_id:context_node.global_node_id)).length.should == 1
        else
          Link::UserLink.where(old_attribute_hash.merge(user:user,global_node_from_id:context_node.global_node_id)).length.should == 1
        end
      end
    end
    [:global, :group].each do |link_type|
      let(:links) {context_node.user_links.send(:"#{link_type}_links")}
      let(:to_be_related_links) {Node::GlobalNode.where(title:new_text)}
      it "should ensure the correct #{link_type}_links have been destroyed and the correct #{link_type}_links have been updated" do
        destroyed = []
        updated_minus_one = []
        links.each do |link|
          if link.user_count == 1 && (to_be_related - link).count == to_be_related.count
            destroyed << link
          elsif (to_be_related - link).count == to_be_related.count
            updated_minus_one << link
          end
        end
        context_node.update_text(new_text)
        to_be_related_links.each do |link|
          (link.users_count + 1).should == link.reload.users_count
        end
        updated_minus_one.each do |link|
          (link.users_count - 1).should == link.reload.users_count
        end
        destroyed.each do |link|
          link.should_not be_persisted
        end
      end
      #if user in fact already owns link??? just switching to other link in space?
      it "should ensure the correct global and group links are created with the correct counts" do
        statuses = {:global_link => true, :group_link => true}
        existing_node = Node::GlobalNode.where(title: new_text)
        changing_node_id = context_node.global_node_id
        other_nodes = Link::UserLink.where("global_node_from_id = ?", changing_node_id).map(&:global_node_to_id)
        other_nodes +=Link::UserLink.where("global_node_to_id = ?", changing_node_id).map(&:global_node_from_id)
        global_links = []
        group_links = []
        user_group_ids = user.groups.map(&:id)
        if existing_node
          other_nodes.each do |node|
            if (global_links += Link::GlobalLink.where("(global_node_from_id = ? && global_node_to_id = ?) || (global_node_from_id = ? && global_node_to_id = ?)", existing_node.id, other_node.id, other_node.id, existing_node.id)).any?
              statuses[:global_link] = false
              if (group_links += Link::GroupLink.where("((global_node_from_id = ? && global_node_to_id = ?) || (global_node_from_id = ? && global_node_to_id = ?)) && group_id IN ?", existing_node.id, other_node.id, other_node.id, existing_node.id, user_group_ids)).any?
                statuses[:group_link] = false
              end
            end
          end
        end
        context_node.update_text(new_text)
        statuses.each do |link_type, status|
          unless status
            send(:"#{link_type}s").each {|link| (link.users_count + 1).should == link.reload.users_count}
          else
            "Link::#{link_type.constantize}".constantize.where("global_node_from_id = ? || global_node_to_id = ?", existing_node.id, existing_node.id).each do |link|
              link.users_count.should == 1
            end
          end
        end
      end
    end
  end
  context "correct node changes" do

    #correct new global node with correct counts
    #remove old context nodes/context nodes answering to that where...
    #should have the correct conclusions
  end
end

shared_examples_for 'context node creating nodes' do
  before do
    @state_hash = @node_state_hash
    @perform ||= 'ContextNode.create(@params)'
  end
  it 'should create the correct number of global_nodes' do
    expect {
      eval(@perform)
    }.to change(Node::GlobalNode, :count).by(@state_hash[:global_node][:number_created])
  end
  it 'should create the correct number of context_nodes' do
    expect {
      eval(@perform)
    }.to change(ContextNode, :count).by(@state_hash[:context_node][:number_created])
  end
  it 'should create the correct global node with the correct users count' do
    cn = eval(@perform)
    cn = (cn.is_a?(ContextNode) ? cn : ContextNode.where(:user_id=>cn.user_id, :question_id=>cn.question_id, :title => cn.global_node_from.title)[0])
    gn = Node::GlobalNode.where(:title => 'Title', :users_count => @state_hash[:global_node][:users_count])
    gn.count.should == 1
    gn[0].id.should == cn.global_node_id
    Node::GlobalNode.where(:title => 'Title').count.should == 1
  end
end
