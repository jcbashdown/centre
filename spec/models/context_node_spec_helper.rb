shared_examples_for 'a context_node correctly updating node text' do
  context "correct links changes" do
    it "should not cause a change in the link count for this user" do
      expect {
        context_node.update_title(new_text)
      }.to change(user.user_links, :count).by 0
    end
    it "should not cause a change in the link count" do
      expect {
        context_node.update_title(new_text)
      }.to change(Link::UserLink, :count).by 0
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
      new_context_node = context_node.update_title(new_text)
      old_attributes.each do |old_attribute_hash|
        if old_attribute_hash[:global_node_from_id]
          Link::UserLink.where(old_attribute_hash.merge(user_id:user.id,global_node_to_id:new_context_node.global_node_id)).length.should == 1
        else
          Link::UserLink.where(old_attribute_hash.merge(user_id:user.id,global_node_from_id:new_context_node.global_node_id)).length.should == 1
        end
      end
    end
    let(:existing) {Node::GlobalNode.where(title:new_text)[0]}
    let(:to_be_related_links_global) {Link::GlobalLink.where('global_node_from_id = ? || global_node_to_id = ?', existing.try(:id), existing.try(:id))}
    let(:to_be_related_links_group) {Link::GroupLink.where(:group_id => context_node.user.groups.map(&:id)).where('global_node_from_id = ? || global_node_to_id = ?', existing.try(:id), existing.try(:id))}
    [:global, :group].each do |link_type|
      let(:to_be_related_links) {send(:"to_be_related_links_#{link_type}")}
      let(:links) {context_node.send(:"#{link_type}_links")}
      it "should ensure the correct #{link_type}_links have been destroyed and the correct #{link_type}_links have been updated" do
        destroyed = []
        updated_minus_one = []
        links.each do |link|
          if link.users_count == 2 && (to_be_related_links - [link]).count == to_be_related_links.count
            destroyed << link
          elsif link.users_count > 2 && (to_be_related_links - [link]).count == to_be_related_links.count
            updated_minus_one << link
          end
        end
        to_be_related_links
        context_node.update_title(new_text)
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
        statuses = {:global_link => false, :group_link => false}
        existing_node = Node::GlobalNode.where(title: new_text)[0]
        changing_node_id = context_node.global_node_id
        other_nodes = Link::UserLink.where("global_node_from_id = ?", changing_node_id).map(&:global_node_to_id)
        other_nodes +=Link::UserLink.where("global_node_to_id = ?", changing_node_id).map(&:global_node_from_id)
        global_links = []
        group_links = []
        user_group_ids = user.groups.map(&:id)
        if existing_node
          other_nodes.each do |node|
            if (global_links += Link::GlobalLink.where("(global_node_from_id = ? && global_node_to_id = ?) || (global_node_from_id = ? && global_node_to_id = ?)", existing_node.id, other_node.id, other_node.id, existing_node.id)).any?
              statuses[:global_link] = true
              if (group_links += Link::GroupLink.where("((global_node_from_id = ? && global_node_to_id = ?) || (global_node_from_id = ? && global_node_to_id = ?)) && group_id IN ?", existing_node.id, other_node.id, other_node.id, existing_node.id, user_group_ids)).any?
                statuses[:group_link] = true
              end
            end
          end
        end
        context_node.update_title(new_text)
        statuses.each do |link_type, link_of_type_exists|
          if link_of_type_exists
            send(:"#{link_type}s").each {|link| (link.users_count + 1).should == link.reload.users_count}
          elsif existing_node
            "Link::#{link_type.to_s.classify}".constantize.where("global_node_from_id = ? || global_node_to_id = ?", existing_node.id, existing_node.id).each do |link|
              link.users_count.should == 1
            end
          else
            new_node = Node::GlobalNode.where(title: new_text)[0]
            "Link::#{link_type.to_s.classify}".constantize.where("global_node_from_id = ? || global_node_to_id = ?", new_node.id, new_node.id).each do |link|
              link.users_count.should == 1
            end
          end
        end
      end
    end
  end
  context "correct node changes" do
    it "should create a global_node if none exists for this title or use the existing one" do
      if existing_node = Node::GlobalNode.where(title: new_text)[0]
        changed_context_node = nil
        expect {
          changed_context_node = context_node.update_title(new_text)
        }.to change(Node::GlobalNode, :count).by 0
        (existing_node.users_count + 1) == changed_context_node.global_node.reload.users_count
        changed_context_node.global_node.should == existing_node
      else
        if context_node.global_node.users_count > 1
          changed_context_node = nil
          expect {
            changed_context_node = context_node.update_title(new_text)
          }.to change(Node::GlobalNode, :count).by 1
          changed_context_node.global_node.reload.users_count.should == 1
          changed_context_node.global_node.title.should == new_text
        else
          changed_context_node = nil
          expect {
            changed_context_node = context_node.update_title(new_text)
          }.to change(Node::GlobalNode, :count).by 0
          changed_context_node.global_node.reload.users_count.should == 1
          changed_context_node.global_node.title.should == new_text
        end
      end
    end
    it "should not change the number of context nodes" do
      expect {
        context_node.update_title(new_text)
      }.to change(ContextNode, :count).by 0
    end
    it "should not change the number of of the correct context nodes" do
      expect {
        context_node.update_title(new_text)
      }.to change(ContextNode.where(user_id:user.id), :count).by 0
    end
    it "should remove the number of old titled context nodes" do
      old_count = ContextNode.where(global_node_id:context_node.global_node_id).count
      expect {
        context_node.update_title(new_text)
      }.to change(ContextNode.where(global_node_id:context_node.global_node_id), :count).by(-old_count)
    end
    it "should create the number of old titled context nodes in new context nodes" do
      old_count = ContextNode.where(global_node_id:context_node.global_node_id).count
      expect {
        context_node.update_title(new_text)
      }.to change(ContextNode.where(title:new_text), :count).by(old_count)
    end
    it "should have one identical new context node with the new title for every old node which featured that title" do
      old_cns = ContextNode.where(global_node_id:context_node.global_node_id)
      new_context_node = context_node.update_title(new_text)
      new_gn_id = new_context_node.reload.global_node_id
      old_cns.each do |cn|
        ContextNode.where(user_id:cn.user_id, question_id:cn.question_id, global_node_id:new_gn_id, is_conclusion:cn.is_conclusion).length.should == 1
      end
    end
    #should have the correct conclusions
  end
  context "correct conclusion changes" do
    it "should ensure the correct changes are made to group_question_conclusions" do
      old = context_node.global_node
      new_cn = context_node.update_title new_text
      new = new_cn.global_node
      context_node.user.groups.each do |group|
        if @conclusion_statuses[:group_question_conclusions][:includes_old]
          group.conclusions.by_question_for_group(question).should include old 
        else
          group.conclusions.by_question_for_group(question).should_not include old 
        end
        if @conclusion_statuses[:group_question_conclusions][:includes_new]
          group.conclusions.by_question_for_group(question).should include new
        else
          group.conclusions.by_question_for_group(question).should_not include new
        end
      end
    end
    it "should ensure the correct changes are made to user_question_conclusions" do
      old = context_node.global_node
      new_cn = context_node.update_title new_text
      new = new_cn.global_node
      if @conclusion_statuses[:user_question_conclusions][:includes_old]
        context_node.user.conclusions.by_question_for_user(question).should include old 
      else
        context_node.user.conclusions.by_question_for_user(question).should_not include old 
      end
      if @conclusion_statuses[:user_question_conclusions][:includes_new]
        context_node.user.conclusions.by_question_for_user(question).should include new
      else
        context_node.user.conclusions.by_question_for_user(question).should_not include new
      end
    end
    it "should ensure the correct changes are made to question_conclusions" do
      old = context_node.global_node
      new_cn = context_node.update_title new_text
      new = new_cn.global_node
      if @conclusion_statuses[:question_conclusions][:includes_old]
        context_node.question.concluding_nodes.should include old 
      else
        context_node.question.concluding_nodes.should_not include old 
      end
      if @conclusion_statuses[:question_conclusions][:includes_new]
        context_node.question.concluding_nodes.should include new
      else
        context_node.question.concluding_nodes.should_not include new
      end
    end
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
