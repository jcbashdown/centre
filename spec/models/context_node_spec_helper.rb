shared_examples_for 'a context_node correctly updating node text' do
  context "correct links changes" do
    it "should not cause a change in the link count for this user" do
      expect {
        context_node.update_title(new_text)
      }.to change(context_node.user.user_links, :count).by 0
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
        attributes_hash[:user_id] = context_node.user_id
        old_attributes << attributes_hash
        old_attributes
      end
      new_context_node = context_node.update_title(new_text)
      old_attributes.each do |old_attribute_hash|
        if old_attribute_hash[:global_node_from_id]
          Link::UserLink.where(old_attribute_hash.merge(global_node_to_id:new_context_node.global_node_id)).length.should == 1
        else
          Link::UserLink.where(old_attribute_hash.merge(global_node_from_id:new_context_node.global_node_id)).length.should == 1
        end
      end
    end
    let(:existing) {Node::GlobalNode.where(title:new_text)[0]}
    let(:to_be_related_links_global) {Link::GlobalLink.where('global_node_from_id = ? || global_node_to_id = ?', existing.try(:id), existing.try(:id))}
    let(:to_be_related_links_group) {Link::GroupLink.where(:group_id => context_node.user.groups.map(&:id)).where('global_node_from_id = ? || global_node_to_id = ?', existing.try(:id), existing.try(:id))}
    [:global, :group].each do |link_type|
      it "should ensure the correct #{link_type}_links have been destroyed and the correct #{link_type}_links have been updated" do
        links = context_node.send(:"#{link_type}_links")
        to_be_related_links = send(:"to_be_related_links_#{link_type}")
        destroyed = []
        updated_minus_one = []
        links.each do |link|
          if (to_be_related_links - [link]).count == to_be_related_links.count#if the link isn't one of the links we're finding/creating and relating
            if link.users_count == 1
              destroyed << link
            elsif link.users_count > 1
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
          params = {global_node_from_id: link.global_node_from_id, global_node_to_id: link.global_node_to_id, type: link.type}
          params.merge!(group_id: link.group_id) if link_type == :group
          Link.send(:"#{link_type}_link").where(params).count.should == 0
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
        user_group_ids = context_node.user.groups.map(&:id)
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
        if context_node.global_node.reload.users_count > ContextNode.where(user_id: context_node.user_id, global_node_id: context_node.global_node_id).count
          changed_context_node = nil
          expect {
            changed_context_node = context_node.update_title(new_text)
          }.to change(Node::GlobalNode, :count).by 1
          changed_context_node.global_node.reload.users_count.should == ContextNode.where(global_node_id:changed_context_node.global_node_id).count
          changed_context_node.global_node.title.should == new_text
        else
          changed_context_node = nil
          expect {
            changed_context_node = context_node.update_title(new_text)
          }.to change(Node::GlobalNode, :count).by 0
          changed_context_node.global_node.reload.users_count.should == ContextNode.where(global_node_id:changed_context_node.global_node_id).count
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
      }.to change(ContextNode.where(user_id:context_node.user_id), :count).by 0
    end
    it "should remove the number of old titled context nodes" do
      old_count = ContextNode.where(user_id: context_node.user_id, global_node_id:context_node.global_node_id).count
      expect {
        context_node.update_title(new_text)
      }.to change(ContextNode.where(global_node_id:context_node.global_node_id), :count).by(-old_count)
    end
    it "should create the number of old titled context nodes in new context nodes" do
      old_count = ContextNode.where(user_id: context_node.user_id, global_node_id:context_node.global_node_id).count
      expect {
        context_node.update_title(new_text)
      }.to change(ContextNode.where(title:new_text), :count).by(old_count)
    end
    it "should have one identical new context node with the new title for every old node which featured that title" do
      old_cns = ContextNode.where(user_id:context_node.user_id, global_node_id:context_node.global_node_id)
      new_context_node = context_node.update_title(new_text)
      new_gn_id = new_context_node.reload.global_node_id
      old_cns.each do |cn|
        ContextNode.where(user_id:cn.user_id, question_id:cn.question_id, global_node_id:new_gn_id, is_conclusion:cn.is_conclusion).length.should == 1
      end
    end
  end
  context "correct conclusion changes" do
    it "should ensure the correct changes are made to group_question_conclusions" do
      if @conclusion_statuses
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
            group.conclusions.reload.by_question_for_group(question).should include new
          else
            group.conclusions.reload.by_question_for_group(question).should_not include new
          end
        end
      end
    end
    it "should ensure the correct changes are made to user_question_conclusions" do
      if @conclusion_statuses
        old = context_node.global_node
        new_cn = context_node.update_title new_text
        new = new_cn.global_node
        if @conclusion_statuses[:user_question_conclusions][:includes_old]
          context_node.user.conclusions.by_question_for_user(question).should include old 
        else
          context_node.user.conclusions.by_question_for_user(question).should_not include old 
        end
        if @conclusion_statuses[:user_question_conclusions][:includes_new]
          context_node.user.conclusions.reload.by_question_for_user(question).should include new
        else
          context_node.user.conclusions.reload.by_question_for_user(question).should_not include new
        end
      end
    end
    it "should ensure the correct changes are made to question_conclusions" do
      if @conclusion_statuses
        old = context_node.global_node
        new_cn = context_node.update_title new_text
        new = new_cn.global_node
        if @conclusion_statuses[:question_conclusions][:includes_old]
          context_node.question.concluding_nodes.should include old 
        else
          context_node.question.concluding_nodes.should_not include old 
        end
        if @conclusion_statuses[:question_conclusions][:includes_new]
          context_node.question.reload.concluding_nodes.should include new
        else
          context_node.question.reload.concluding_nodes.should_not include new
        end
      end
    end
  end
end

shared_examples_for 'context node creating nodes' do
  before do
    @state_hash = @node_state_hash
    @perform ||= 'Node::UserNode.create(@params)'
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
    cn = (cn.is_a?(ContextNode) || cn.is_a?(Node::UserNode) ? cn : ContextNode.where(:user_id=>cn.user_id, :question_id=>cn.question_id, :title => cn.global_node_from.title)[0])
    gn = Node::GlobalNode.where(:title => 'Title', :users_count => @state_hash[:global_node][:users_count])
    gn.count.should == 1
    gn[0].id.should == cn.global_node_id
    Node::GlobalNode.where(:title => 'Title').count.should == 1
  end
end

shared_examples_for "a node deleting nodes correctly" do |type|
  context 'when there are no associated links' do
    describe 'when the question nodes question node user count is less than two (when there is only this user)' do
      before do
        context_node = Node::UserNode.create(:user=>@user, :title=>'Title', :question=>@question, :is_conclusion => false)
      end
      it 'should destroy 1 node' do
        expect {
          ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
        }.to change(Node::GlobalNode, :count).by(-1)
      end
      it 'should destroy 1 questions_nodes_users' do
        expect {
          ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
        }.to change(ContextNode, :count).by(-1)
      end
      it 'should destroy the node' do
        ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
        Node::GlobalNode.where(:title=>'Title')[0].should be_nil
      end
      it 'should destroy the question node user' do
        ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
        ContextNode.where(:title=>'Title', :question_id=>@question.id)[0].should be_nil
      end
      context 'with another user for the question node' do
        before do
          @user = FactoryGirl.create(:user, :email => "a@test.com")
          context_node = ContextNode.create(:user=>@user, :title=>'Title', :question=>@question, :is_conclusion => false)
        end
        it 'should destroy 0 global_nodes' do
          expect {
            ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
          }.to change(Node::GlobalNode, :count).by(0)
        end
        it 'should destroy 1 questions_nodes_users' do
          expect {
            ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
          }.to change(ContextNode, :count).by(-1)
        end
        it 'should update the caches' do
          ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
          gn = Node::GlobalNode.where(:title=>'Title')[0]
          gn.should_not be_nil
          gn.users_count.should == 1
        end
        it 'should not destroy the node and question node and should destroy the context_node' do
          @user_two = FactoryGirl.create(:user, :email=>"another@test.com")
          context_node = ContextNode.create(:user=>@user_two, :question=>@question, :title => 'Title', :is_conclusion => true)
          ContextNode.where(:user_id=>@user_two.id, :title=>'Title', :question_id=>@question.id, :is_conclusion => true).count.should == 1
          @user_three = FactoryGirl.create(:user, :email=>"another@test2.com")
          context_node = ContextNode.create(:user=>@user_three, :question=>@question, :title => 'Title', :is_conclusion => true)
          ContextNode.where(:user_id=>@user_three.id, :title=>'Title', :question_id=>@question.id, :is_conclusion => true).count.should == 1
          ContextNode.where(:user_id=>@user.id, :title=>'Title', :question_id=>@question.id)[0].destroy
          
          Node::GlobalNode.where(:title=>'Title')[0].should_not be_nil
          ContextNode.where(:title=>'Title', :user_id => @user.id, :question_id=>@question.id)[0].should be_nil
        end
      end
    end
  end
  describe 'with existing links' do
    before do
      @group.users << @user
      @context_node1 = ContextNode.create(:title => 'title', :question => @question, :user => @user)
      @context_node2 = ContextNode.create(:title => 'test', :question => @question, :user => @user)
      @context_node3 = ContextNode.create(:title => 'another', :question => @question, :user => @user)
      @context_link = Link::UserLink::PositiveUserLink.create(:user=>@user, :question => @question, :global_node_from_id => @context_node1.global_node.id, :global_node_to_id => @context_node2.global_node.id)
    end
    it 'should destroy 1 node' do
      expect {
        @context_node1.destroy
      }.to change(Node::GlobalNode, :count).by(-1)
    end
    it 'should destroy 1 questions_nodes_users' do
      expect {
        @context_node1.destroy
      }.to change(ContextNode, :count).by(-1)
    end
    it 'should destroy 1 link' do
      expect {
        @context_node1.destroy
      }.to change(Link::GlobalLink, :count).by(-1)
    end

    it 'should destroy 1 context_link' do
      expect {
        @context_node1.destroy
      }.to change(Link::GroupLink, :count).by(-1)
    end

    it 'should destroy 1 context_link' do
      expect {
        @context_node1.destroy
      }.to change(Link::UserLink, :count).by(-1)
    end

    it 'update the caches' do
      #@context_node2.reload.upvotes_count.should == 1
      @context_node2.global_node.reload.upvotes_count.should == 1
      @context_node1.destroy
      #@context_node2.reload.upvotes_count.should == 0 
      @context_node2.global_node.reload.upvotes_count.should == 0
    end
    
    context 'when another user has the link in this question' do
      before do
        @group.users << @user_two
        @context_link2 = Link::UserLink::PositiveUserLink.create(:user=>@user_two, :question => @question, :global_node_from_id => @context_node1.global_node.id, :global_node_to_id => @context_node2.global_node.id)
      end
      it 'should destroy 0 node' do
        expect {
          @context_node1.destroy
        }.to change(Node::GlobalNode, :count).by(0)
      end
      it 'should destroy 1 questions_nodes_users' do
        expect {
          @context_node1.destroy
        }.to change(ContextNode, :count).by(-1)
      end
      it 'should destroy 0 link' do
        expect {
          @context_node1.destroy
        }.to change(Link::GlobalLink, :count).by(0)
      end

      it 'should destroy 0 gl' do
        expect {
          @context_node1.destroy
        }.to change(Link::GroupLink, :count).by(0)
      end

      it 'should destroy 1 lu' do
        expect {
          @context_node1.destroy
        }.to change(Link::UserLink, :count).by(-1)
      end

      it 'update the caches' do
        #@context_node2.reload.upvotes_count.should == 1
        @context_node2.global_node.reload.upvotes_count.should == 2
        @context_node1.destroy
        #@context_node2.reload.upvotes_count.should == 0 
        @context_node2.global_node.reload.upvotes_count.should == 1
      end
    end

    context 'when another user has another link in this question which uses the same node from' do
      before do
        @group.users << @user
        @context_link2 = Link::UserLink::PositiveUserLink.create(:user=>@user_two, :question => @question, :global_node_from_id => @context_node1.global_node.id, :global_node_to_id => @context_node3.global_node.id)
      end
      it 'should destroy 0 node (due to shared node from and diff users)' do
        expect {
          @context_node1.destroy
        }.to change(Node::GlobalNode, :count).by(0)
      end
      it 'should destroy 1 questions_nodes_users' do
        expect {
          @context_node1.destroy
        }.to change(ContextNode, :count).by(-1)
      end

      it 'should destroy 1 link' do
        expect {
          @context_node1.destroy
        }.to change(Link::GlobalLink, :count).by(-1)
      end

      it 'should destroy 1 gl' do
        expect {
          @context_node1.destroy
        }.to change(Link::GroupLink, :count).by(-1)
      end

      it 'should destroy 1 lu' do
        expect {
          @context_node1.destroy
        }.to change(Link::UserLink, :count).by(-1)
      end

      it 'update the caches' do
        #@context_node2.reload.upvotes_count.should == 1
        @context_node2.global_node.reload.upvotes_count.should == 1
        @context_node1.destroy
        #@context_node2.reload.upvotes_count.should == 0 
        @context_node2.global_node.reload.upvotes_count.should == 0
      end
    end

    context 'when another user has the link in another question' do
      before do
        @group2.users << @user_two
        @context_link2 = Link::UserLink::PositiveUserLink.create(:user=>@user_two, :question => @question2, :global_node_from_id => @context_node1.global_node.id, :global_node_to_id => @context_node2.global_node.id)
      end
      it 'should destroy 0 node' do
        expect {
          @context_node1.destroy
        }.to change(Node::GlobalNode, :count).by(0)
      end
      it 'should destroy 1 questions_nodes_users' do
        expect {
          @context_node1.destroy
        }.to change(ContextNode, :count).by(-1)
      end

      it 'should destroy 0 link' do
        expect {
          @context_node1.destroy
        }.to change(Link::GlobalLink, :count).by(0)
      end

      it 'should destroy 1 gl' do
        expect {
          @context_node1.destroy
        }.to change(Link::GroupLink, :count).by(-1)
      end

      it 'should destroy 1 lu' do
        expect {
          @context_node1.destroy
        }.to change(Link::UserLink, :count).by(-1)
      end

      it 'update the caches' do
        #@context_node2.reload.upvotes_count.should == 1
        @context_node2.global_node.reload.upvotes_count.should == 2
        @context_node1.destroy
        #@context_node2.reload.upvotes_count.should == 0 
        @context_node2.global_node.reload.upvotes_count.should == 1
      end
    end

    context 'when the user has the link in another question' do
      before do
        @user.groups << @group2
        @context_link2 = Link::UserLink::PositiveUserLink.create(:user=>@user, :question => @question2, :global_node_from_id => @context_node1.global_node.id, :global_node_to_id => @context_node2.global_node.id)
      end
      it 'should destroy 0 node' do
        expect {
          @context_node1.destroy
        }.to change(Node::GlobalNode, :count).by(0)
      end
      it 'should destroy 1 questions_nodes_users' do
        expect {
          @context_node1.destroy
        }.to change(ContextNode, :count).by(-1)
      end

      it 'should destroy 0 link' do
        expect {
          @context_node1.destroy
        }.to change(Link::GlobalLink, :count).by(-1)
      end

      it 'should destroy 1 gl' do
        expect {
          @context_node1.destroy
        }.to change(Link::GroupLink, :count).by(-2)
      end

      it 'should destroy 1 lu' do
        expect {
          @context_node1.destroy
        }.to change(Link::UserLink, :count).by(-1)
      end

      it 'update the caches' do
        #@context_node2.reload.upvotes_count.should == 1
        @context_node2.global_node.reload.upvotes_count.should == 1
        @context_node1.destroy
        #@context_node2.reload.upvotes_count.should == 0 
        @context_node2.global_node.reload.upvotes_count.should == 0
      end
    end

    context 'when the user has another link in this question where the links share a node from' do
      before do
        @group.users << @user
        @context_link2 = Link::UserLink::PositiveUserLink.create(:user=>@user, :question => @question, :global_node_from_id => @context_node1.global_node.id, :global_node_to_id => @context_node3.global_node.id)
      end
      it 'should destroy 1 node (despite shared node from -- all on user)' do
        expect {
          @context_node1.destroy
        }.to change(Node::GlobalNode, :count).by(-1)
      end
      it 'should destroy 1 questions_nodes_users' do
        expect {
          @context_node1.destroy
        }.to change(ContextNode, :count).by(-1)
      end

      it 'should destroy 1 link' do
        expect {
          @context_node1.destroy
        }.to change(Link::GlobalLink, :count).by(-2)
      end

      it 'should destroy 1 context_link' do
        expect {
          @context_node1.destroy
        }.to change(Link::GroupLink, :count).by(-2)
      end

      it 'should destroy 1 context_link' do
        expect {
          @context_node1.destroy
        }.to change(Link::UserLink, :count).by(-2)
      end

      it 'update the caches' do
        #@context_node2.reload.upvotes_count.should == 1
        @context_node2.global_node.reload.upvotes_count.should == 1
        #@context_node3.reload.upvotes_count.should == 1
        @context_node3.global_node.reload.upvotes_count.should == 1
        @context_node1.destroy
        #@context_node2.reload.upvotes_count.should == 0 
        @context_node2.global_node.reload.upvotes_count.should == 0
        #@context_node3.reload.upvotes_count.should == 0 
        @context_node3.global_node.reload.upvotes_count.should == 0
      end
    end
  end
end
