shared_examples_for 'a context link creating links' do |type|
  it 'should create the correct number of group links' do
    expect {
      "Link::UserLink::#{type}UserLink".constantize.create(@params)
    }.to change(Link::GroupLink, :count).by(@state_hash[:group_link][:number_created])
  end
  it 'should create the correct number of the correct group links' do
    expect {
      "Link::UserLink::#{type}UserLink".constantize.create(@params)
    }.to change("Link::GroupLink::#{type}GroupLink".constantize, :count).by(@state_hash[:group_link][:number_created])
  end
  it 'should have the correct number of the correct group links before and after creation' do
    "Link::GroupLink::#{type}GroupLink".constantize.count.should == @state_hash[:group_link][:number_existing_before]
    "Link::UserLink::#{type}UserLink".constantize.create(@params)
    "Link::GroupLink::#{type}GroupLink".constantize.count.should == @state_hash[:group_link][:number_existing_before] + @state_hash[:group_link][:number_created]
  end
  it 'should create the ql with the correct counts' do
    context_link = "Link::UserLink::#{type}UserLink".constantize.create(@params)
    Link::GroupLink.where(:group_id => @group.id, :global_link_id => context_link.global_link_id)[0].users_count.should == @state_hash[:group_link][:users_count]
  end
  it 'should create the ql with the correct activation' do
    context_link = "Link::UserLink::#{type}UserLink".constantize.create(@params)
    Link::GroupLink.where(:group_id => @group.id, :global_link_id => context_link.global_link_id)[0].should == Link::GroupLink.active_for({:group_id => @group.id, :global_node_from_id => context_link.global_node_from_id, :global_node_to_id => context_link.global_node_to_id}) if @state_hash[:group_link][:activation]
  end
  it 'should create the correct number of uls' do
    expect {
      "Link::UserLink::#{type}UserLink".constantize.create(@params)
    }.to change(Link::UserLink, :count).by(@state_hash[:user_link][:number_created])
  end
  it 'should create the correct number of the correct uls' do
    expect {
      "Link::UserLink::#{type}UserLink".constantize.create(@params)
    }.to change("Link::UserLink::#{type}UserLink".constantize, :count).by(@state_hash[:user_link][:number_created])
  end
  it 'should maintain a single ul for this user link combination only' do
    context_link = "Link::UserLink::#{type}UserLink".constantize.create(@params)
    Link::UserLink.where(:user_id => @user.id, :global_link_id => context_link.global_link_id).count.should == 1
  end
  it 'should create the correct number of gls' do
    expect {
      "Link::UserLink::#{type}UserLink".constantize.create(@params)
    }.to change(Link::GlobalLink, :count).by(@state_hash[:global_link][:number_created])
  end
  it 'should create the correct number of the correct gls' do
    expect {
      "Link::UserLink::#{type}UserLink".constantize.create(@params)
    }.to change("Link::GlobalLink::#{type}GlobalLink".constantize, :count).by(@state_hash[:global_link][:number_created])
  end
  it 'should create the gl with the correct counts' do
    context_link = "Link::UserLink::#{type}UserLink".constantize.create(@params)
    context_link.global_link.reload.users_count.should == @state_hash[:global_link][:users_count]
  end
  it 'should create the gl with the correct activation' do
    context_link = "Link::UserLink::#{type}UserLink".constantize.create(@params)
    context_link.global_link.should == Link::GlobalLink.active_for({global_node_from_id: context_link.global_node_from_id, global_node_to_id: context_link.global_node_to_id}) if @state_hash[:global_link][:activation]
  end
  it 'should create the correct number of context nodes' do
    ContextNode.should_receive(:create!).exactly(@state_hash[:context_node][:find_or_create_calls]).times.and_return @gnu1
    "Link::UserLink::#{type}UserLink".constantize.create(@params)
  end
  it 'should create the correct number of context nodes' do
    expect {
      "Link::UserLink::#{type}UserLink".constantize.create(@params)
    }.to change(ContextNode, :count).by(@state_hash[:context_node][:number_created])
  end
  it 'should have persisted gnus to and from' do
    user_link = "Link::UserLink::#{type}UserLink".constantize.create(@params)
    context_node_froms = ContextNode.where(:user_id=>user_link.user_id, :question_id=>user_link.question_id, :title => user_link.global_node_from.title)
    context_node_tos = ContextNode.where(:user_id=>user_link.user_id, :question_id=>user_link.question_id, :title => user_link.global_node_to.title)
    context_node_froms.length.should == 1
    context_node_tos.length.should == 1
    context_node_froms[0].should be_persisted
    context_node_tos[0].should be_persisted
  end
end
#shared_examples_for 'a context_link updating links' do |type, @state_hash|
#
#end
shared_examples_for 'a @context_link deleting links' do |type|
  before do
    @ul_attrs = {:global_link_id => @context_link.global_link_id, :user_id => @user.id}
    @gl_attrs = {:global_node_from_id => @context_link.global_node_from.id, :global_node_to_id => @context_link.global_node_to.id}
    @grl_attrs = {:global_link_id => @context_link.global_link_id, :group_id => @group.try(:id)}
  end
  it 'should destroy the correct number of group links' do
    expect {
      @context_link.destroy
    }.to change(Link::GroupLink, :count).by(@state_hash[:group_link][:number_destroyed])
  end
  it 'should destroy the correct number of the correct group links' do
    expect {
      @context_link.destroy
    }.to change("Link::GroupLink::#{type}GroupLink".constantize, :count).by(@state_hash[:group_link][:number_destroyed])
  end
  it 'should destroy the ql with the correct counts' do
    @context_link.destroy
    "Link::GroupLink::#{type}GroupLink".constantize.where(@grl_attrs)[0].try(:users_count).should == @state_hash[:group_link][:users_count]
  end
  it 'should destroy the ql with the correct activation' do
    @context_link.destroy
    "Link::GroupLink::#{type}GroupLink".constantize.where(@grl_attrs)[0].should == Link::GroupLink.active_for({global_node_from_id: @context_link.global_node_from_id, global_node_to_id: @context_link.global_node_to_id, group_id: @group.id}) if @state_hash[:group_link][:activation]
  end
  it 'should destroy the correct number of uls' do
    expect {
      @context_link.destroy
    }.to change(Link::UserLink, :count).by(@state_hash[:user_link][:number_destroyed])
  end
  it 'should destroy the correct number of the correct uls' do
    expect {
      @context_link.destroy
    }.to change("Link::UserLink::#{type}UserLink".constantize, :count).by(@state_hash[:user_link][:number_destroyed])
  end
  it 'should destroy the ul with the correct counts' do
    @context_link.destroy
    "Link::UserLink::#{type}UserLink".constantize.where(@ul_attrs)[0].try(:users_count).should == @state_hash[:user_link][:users_count]
  end
  it 'should destroy the correct number of gls' do
    expect {
      @context_link.destroy
    }.to change(Link::GlobalLink, :count).by(@state_hash[:global_link][:number_destroyed])
  end
  it 'should destroy the correct number of the correct gls' do
    expect {
      @context_link.destroy
    }.to change("Link::GlobalLink::#{type}GlobalLink".constantize, :count).by(@state_hash[:global_link][:number_destroyed])
  end
  it 'should destroy the gl with the correct counts' do
    @context_link.destroy
    "Link::GlobalLink::#{type}GlobalLink".constantize.where(@gl_attrs)[0].try(:users_count).should == @state_hash[:global_link][:users_count]
  end
  it 'should destroy the gl with the correct activation' do
    @context_link.destroy
    "Link::GlobalLink::#{type}GlobalLink".constantize.where(@gl_attrs)[0].should == Link::GlobalLink.active_for(@gl_attrs) if @state_hash[:global_link][:activation]
  end
  it 'should have the correct votes on the gns' do
    @context_link.destroy
    @state_hash[:new_global_node_to].each do |key, value|
      @context_link.try(:global_node_to).try(:reload).try(key).should == value
    end
    @state_hash[:new_global_node_from].each do |key, value|
      @context_link.try(:global_node_from).try(:reload).try(key).should == value
    end
  end
end
shared_examples_for 'a @context_link updating links' do |new_type, old_type|
  let(:ul_attrs) {{:global_link_id => @context_link.global_link_id, :user_id => @user.id}}
  let(:gl_attrs) {{:global_node_from_id => @context_link.global_node_from.id, :global_node_to_id => @context_link.global_node_to.id}}
  let(:grl_attrs) {{:global_link_id => @context_link.global_link_id, :group_id => @group.try(:id)}}

  it 'should destroy the correct number of group links' do
    expect {
      @context_link.update_type(new_type, @question)
    }.to change(Link::GroupLink, :count).by(@state_hash[:group_link][:number_destroyed]+@state_hash[:group_link][:number_created])
  end
  it 'should destroy the correct number of the old group links' do
    expect {
      @context_link.update_type(new_type, @question)
    }.to change("Link::GroupLink::#{old_type}GroupLink".constantize, :count).by(@state_hash[:group_link][:number_destroyed])
  end
  it 'should create the correct number of the new group links' do
    expect {
      @context_link.update_type(new_type, @question)
    }.to change("Link::GroupLink::#{new_type}GroupLink".constantize, :count).by(@state_hash[:group_link][:number_created])
  end
  it 'should destroy the old gl with the correct counts' do
    @context_link = @context_link.update_type(new_type, @question)
    "Link::GroupLink::#{old_type}GroupLink".constantize.where(grl_attrs)[0].try(:users_count).should == @state_hash[:old_group_link][:users_count]
  end
  it 'should destroy the old gl with the correct activation' do
    @context_link = @context_link.update_type(new_type, @question)
    "Link::GroupLink::#{old_type}GroupLink".constantize.where(grl_attrs).should == Link::GroupLink.active_for({global_node_from_id: @context_link.global_node_from_id, global_node_to_id: @context_link.global_node_to_id, group_id: @group.try(:id)}) if @state_hash[:old_group_link][:activation]
  end
  it 'should create the new gl with the correct counts' do
    @context_link = @context_link.update_type(new_type, @question)
    "Link::GroupLink::#{new_type}GroupLink".constantize.where(grl_attrs)[0].try(:users_count).should == @state_hash[:new_group_link][:users_count]
  end
  it 'should create the new gl with the correct activation' do
    @context_link = @context_link.update_type(new_type, @question)
    "Link::GroupLink::#{new_type}GroupLink".constantize.where(grl_attrs)[0].should == Link::GroupLink.active_for({global_node_from_id: @context_link.global_node_from_id, global_node_to_id: @context_link.global_node_to_id, group_id: @group.try(:id)}) if @state_hash[:new_group_link][:activation]
  end
  it 'should update the correct number of uls' do
    @context_link = @context_link.update_type(new_type, @question)
    Link::UserLink.where(ul_attrs).count.should == 1
    Link::UserLink.where(ul_attrs)[0].class.should == "Link::UserLink::#{new_type}UserLink".constantize
  end
  it 'should update the ul to the correct counts' do
    @context_link = @context_link.update_type(new_type, @question)
    "Link::UserLink::#{new_type}UserLink".constantize.where(ul_attrs)[0].try(:users_count).should == @state_hash[:user_link][:users_count]
  end
  it 'should maintain a single ul for this user link combination only' do
    @context_link = @context_link.update_type(new_type, @question)
    Link::UserLink.where(:user_id => @user.id, :global_link_id => @context_link.global_link_id).count.should == 1
  end
  it 'should destroy the correct number of gls' do
    expect {
      @context_link.update_type(new_type, @question)
    }.to change(Link::GlobalLink, :count).by(@state_hash[:global_link][:number_destroyed]+@state_hash[:global_link][:number_created])
  end
  it 'should destroy the correct number of the old gls' do
    expect {
      @context_link.update_type(new_type, @question)
    }.to change("Link::GlobalLink::#{old_type}GlobalLink".constantize, :count).by(@state_hash[:global_link][:number_destroyed])
  end
  it 'should create the correct number of the new gls' do
    expect {
      @context_link.update_type(new_type, @question)
    }.to change("Link::GlobalLink::#{new_type}GlobalLink".constantize, :count).by(@state_hash[:global_link][:number_created])
  end
  it 'should destroy the old gl with the correct counts' do
    @context_link = @context_link.update_type(new_type, @question)
    "Link::GlobalLink::#{old_type}GlobalLink".constantize.where(gl_attrs)[0].try(:users_count).should == @state_hash[:old_global_link][:users_count]
  end
  it 'should destroy the old gl with the correct activation' do
    @context_link = @context_link.update_type(new_type, @question)
    "Link::GlobalLink::#{old_type}GlobalLink".constantize.where(gl_attrs)[0].should == Link::GlobalLink.active_for(gl_attrs) if @state_hash[:old_global_link][:activation]
  end
  it 'should create the new gl with the correct counts' do
    @context_link = @context_link.update_type(new_type, @question)
    "Link::GlobalLink::#{new_type}GlobalLink".constantize.where(gl_attrs)[0].try(:users_count).should == @state_hash[:new_global_link][:users_count]
  end
  it 'should create the new gl with the correct activation' do
    @context_link = @context_link.update_type(new_type, @question)
    "Link::GlobalLink::#{new_type}GlobalLink".constantize.where(gl_attrs)[0].should == Link::GlobalLink.active_for(gl_attrs) if @state_hash[:new_global_link][:activation]
  end
  it 'should have the correct votes on the gns' do
    @state_hash[:old_global_node_to].each do |key, value|
      @context_link.try(:global_node_to).try(:reload).try(key).should == value
    end
    @state_hash[:old_global_node_from].each do |key, value|
      @context_link.try(:global_node_from).try(:reload).try(key).should == value
    end
    @context_link = @context_link.update_type(new_type, @question)
    @state_hash[:new_global_node_to].each do |key, value|
      @context_link.try(:global_node_to).try(:reload).try(key).should == value
    end
    @state_hash[:new_global_node_from].each do |key, value|
      @context_link.try(:global_node_from).try(:reload).try(key).should == value
    end
  end

end
