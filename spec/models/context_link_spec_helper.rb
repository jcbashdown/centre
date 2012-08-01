shared_examples_for 'a context link creating links' do |type|
  it 'should create the correct number of context links' do
    expect {
      "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    }.to change(ContextLink, :count).by(@state_hash[:context_link][:number_created])
  end
  it 'should create the correct number of the correct context links' do
    expect {
      "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    }.to change("ContextLink::#{type}ContextLink".constantize, :count).by(@state_hash[:context_link][:number_created])
  end
  it 'should create the correct number of question links' do
    expect {
      "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    }.to change(Link::QuestionLink, :count).by(@state_hash[:question_link][:number_created])
  end
  it 'should create the correct number of the correct question links' do
    expect {
      "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    }.to change("Link::QuestionLink::#{type}QuestionLink".constantize, :count).by(@state_hash[:question_link][:number_created])
  end
  it 'should create the ql with the correct counts' do
    context_link = "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    context_link.question_link.reload.users_count.should == @state_hash[:question_link][:users_count]
  end
  it 'should create the ql with the correct activation' do
    context_link = "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    context_link.question_link.reload.active.should == @state_hash[:question_link][:activation]
  end
  it 'should create the correct number of uls' do
    expect {
      "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    }.to change(Link::UserLink, :count).by(@state_hash[:user_link][:number_created])
  end
  it 'should create the correct number of the correct uls' do
    expect {
      "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    }.to change("Link::UserLink::#{type}UserLink".constantize, :count).by(@state_hash[:user_link][:number_created])
  end
  it 'should create the ul with the correct counts' do
    context_link = "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    context_link.user_link.reload.users_count.should == @state_hash[:user_link][:users_count]
  end
  it 'should create the ul with the correct activation' do
    context_link = "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    context_link.user_link.reload.active.should == @state_hash[:user_link][:activation]
  end
  it 'should create the correct number of gls' do
    expect {
      "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    }.to change(Link::GlobalLink, :count).by(@state_hash[:global_link][:number_created])
  end
  it 'should create the correct number of the correct gls' do
    expect {
      "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    }.to change("Link::GlobalLink::#{type}GlobalLink".constantize, :count).by(@state_hash[:global_link][:number_created])
  end
  it 'should create the gl with the correct counts' do
    context_link = "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    context_link.global_link.reload.users_count.should == @state_hash[:global_link][:users_count]
  end
  it 'should create the gl with the correct activation' do
    context_link = "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    context_link.global_link.reload.active.should == @state_hash[:global_link][:activation]
  end
  it 'should create the correct number of context nodes' do
    ContextNode.should_receive(:find_or_create_by_user_id_and_question_id_and_title).exactly(@state_hash[:context_node][:find_or_create_calls]).times.and_return @gnu1
    "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
  end
  it 'should create the correct number of context nodes' do
    expect {
      "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    }.to change(ContextNode, :count).by(@state_hash[:context_node][:number_created])
  end
  it 'should have persisted gnus to and from' do
    context_link = "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    context_link.context_node_from.should be_persisted
    context_link.context_node_to.should be_persisted
  end
  it 'should have the correct votes on the gns' do
    context_link = "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    @state_hash[:new_global_node_to].each do |key, value|
      context_link.global_link.global_node_to.send(key).should == value
    end
    @state_hash[:new_global_node_from].each do |key, value|
      context_link.global_link.global_node_from.send(key).should == value
    end
  end
  it 'should have the correct votes on the qns' do
    context_link = "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    @state_hash[:new_question_node_to].each do |key, value|
      context_link.question_link.question_node_to.send(key).should == value
    end
    @state_hash[:new_question_node_from].each do |key, value|
      context_link.question_link.question_node_from.send(key).should == value
    end
  end
  it 'should have the correct votes on the uns' do
    context_link = "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    @state_hash[:new_user_node_to].each do |key, value|
      context_link.user_link.user_node_to.send(key).should == value
    end
    @state_hash[:new_user_node_from].each do |key, value|
      context_link.user_link.user_node_from.send(key).should == value
    end
  end
end
#shared_examples_for 'a context_link updating links' do |type, @state_hash|
#
#end
shared_examples_for 'a @context_link deleting links' do |type|
  before do
    @ul_attrs = {:node_from_id => @context_link.user_node_from.id, :node_to_id => @context_link.user_node_to.id, :user_id => @user.id}
    @gl_attrs = {:node_from_id => @context_link.global_node_from.id, :node_to_id => @context_link.global_node_to.id}
    @ql_attrs = {:node_from_id => @context_link.question_node_from.id, :node_to_id => @context_link.question_node_to.id, :question_id => @question.id}
  end
  it 'should destroy the correct number of context links' do
    expect {
      @context_link.destroy
    }.to change(ContextLink, :count).by(@state_hash[:context_link][:number_destroyed])
  end
  it 'should destroy the correct number of the correct context links' do
    expect {
      @context_link.destroy
    }.to change("ContextLink::#{type}ContextLink".constantize, :count).by(@state_hash[:context_link][:number_destroyed])
  end
  it 'should destroy the correct number of question links' do
    expect {
      @context_link.destroy
    }.to change(Link::QuestionLink, :count).by(@state_hash[:question_link][:number_destroyed])
  end
  it 'should destroy the correct number of the correct question links' do
    expect {
      @context_link.destroy
    }.to change("Link::QuestionLink::#{type}QuestionLink".constantize, :count).by(@state_hash[:question_link][:number_destroyed])
  end
  it 'should destroy the ql with the correct counts' do
    @context_link.destroy
    "Link::QuestionLink::#{type}QuestionLink".constantize.where(@ql_attrs)[0].try(:users_count).should == @state_hash[:question_link][:users_count]
  end
  it 'should destroy the ql with the correct activation' do
    @context_link.destroy
    "Link::QuestionLink::#{type}QuestionLink".constantize.where(@ql_attrs)[0].try(:active).should == @state_hash[:question_link][:activation]
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
  it 'should destroy the ul with the correct activation' do
    @context_link.destroy
    "Link::UserLink::#{type}UserLink".constantize.where(@ul_attrs)[0].try(:active).should == @state_hash[:user_link][:activation]
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
    "Link::GlobalLink::#{type}GlobalLink".constantize.where(@gl_attrs)[0].try(:active).should == @state_hash[:global_link][:activation]
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
  it 'should have the correct votes on the qns' do
    @context_link.destroy
    @state_hash[:new_question_node_to].each do |key, value|
      @context_link.try(:question_node_to).try(:reload).try(key).should == value
    end
    @state_hash[:new_question_node_from].each do |key, value|
      @context_link.try(:question_node_from).try(:reload).try(key).should == value
    end
  end
  it 'should have the correct votes on the uns' do
    @context_link.destroy
    @state_hash[:new_user_node_to].each do |key, value|
      @context_link.try(:user_node_to).try(:reload).try(key).should == value
    end
    @state_hash[:new_user_node_from].each do |key, value|
      @context_link.try(:user_node_from).try(:reload).try(key).should == value
    end
  end
end
shared_examples_for 'a @context_link updating links' do |new_type, old_type|
  before do
    @ul_attrs = {:node_from_id => @context_link.user_node_from.id, :node_to_id => @context_link.user_node_to.id, :user_id => @user.id}
    @gl_attrs = {:node_from_id => @context_link.global_node_from.id, :node_to_id => @context_link.global_node_to.id}
    @ql_attrs = {:node_from_id => @context_link.question_node_from.id, :node_to_id => @context_link.question_node_to.id, :question_id => @question.id}
  end
  it 'should update the correct number of context links' do
    old_cls = ContextLink.where(:user_link_id => @context_link.user_link_id)
    @context_link.update_type(new_type)
    old_cls.each do cl
       cl.should_not be_persisted
      "ContexLink::#{new_type}ContextLink".constantize.where({:user => cl.user, :question => cl.question, :global_node_from_id => cl.global_node_from_id, :global_node_to_id => cl.global_node_to_id})[0].should be_persisted
    end
  end
  it 'should destroy the correct number of question links' do
    expect {
      @context_link.update_type(new_type)
    }.to change(Link::QuestionLink, :count).by(@state_hash[:question_link][:number_destroyed]+@state_hash[:question_link][:number_created])
  end
  it 'should destroy the correct number of the old question links' do
    expect {
      @context_link.update_type(new_type)
    }.to change("Link::QuestionLink::#{old_type}QuestionLink".constantize, :count).by(@state_hash[:question_link][:number_destroyed])
  end
  it 'should create the correct number of the new question links' do
    expect {
      @context_link.update_type(new_type)
    }.to change("Link::QuestionLink::#{new_type}QuestionLink".constantize, :count).by(@state_hash[:question_link][:number_created])
  end
  it 'should destroy the old ql with the correct counts' do
    @context_link.update_type(new_type)
    "Link::QuestionLink::#{old_type}QuestionLink".constantize.where(@ql_attrs)[0].try(:users_count).should == @state_hash[:old_question_link][:users_count]
  end
  it 'should destroy the old ql with the correct activation' do
    @context_link.update_type(new_type)
    "Link::QuestionLink::#{old_type}QuestionLink".constantize.where(@ql_attrs)[0].try(:active).should == @state_hash[:old_question_link][:activation]
  end
  it 'should create the new ql with the correct counts' do
    @context_link.update_type(new_type)
    "Link::QuestionLink::#{new_type}QuestionLink".constantize.where(@ql_attrs)[0].try(:users_count).should == @state_hash[:new_question_link][:users_count]
  end
  it 'should create the new ql with the correct activation' do
    @context_link.update_type(new_type)
    "Link::QuestionLink::#{new_type}QuestionLink".constantize.where(@ql_attrs)[0].try(:active).should == @state_hash[:new_question_link][:activation]
  end
  it 'should update the correct number of uls' do
    @context_link.update_type(new_type)
    Link::UserLink.where(@ul_attrs).count.should == 1
    Link::UserLink.where(@ul_attrs)[0].class.should == "Link::UserLink::#{new_type}UserLink".constantize
  end
  it 'should update the ul to the correct counts' do
    @context_link.update_type(new_type)
    "Link::UserLink::#{new_type}UserLink".constantize.where(@ul_attrs)[0].try(:users_count).should == @state_hash[:user_link][:users_count]
  end
  it 'should update the ul to the correct activation' do
    @context_link.update_type(new_type)
    "Link::UserLink::#{new_type}UserLink".constantize.where(@ul_attrs)[0].try(:active).should == @state_hash[:user_link][:activation]
  end
  it 'should destroy the correct number of gls' do
    expect {
      @context_link.update_type(new_type)
    }.to change(Link::GlobalLink, :count).by(@state_hash[:global_link][:number_destroyed]+@state_hash[:global_link][:number_created])
  end
  it 'should destroy the correct number of the old gls' do
    expect {
      @context_link.update_type(new_type)
    }.to change("Link::GlobalLink::#{old_type}GlobalLink".constantize, :count).by(@state_hash[:global_link][:number_destroyed])
  end
  it 'should create the correct number of the new gls' do
    expect {
      @context_link.update_type(new_type)
    }.to change("Link::GlobalLink::#{new_type}GlobalLink".constantize, :count).by(@state_hash[:global_link][:number_created])
  end
  it 'should destroy the old gl with the correct counts' do
    @context_link.update_type(new_type)
    "Link::GlobalLink::#{old_type}GlobalLink".constantize.where(@gl_attrs)[0].try(:users_count).should == @state_hash[:old_global_link][:users_count]
  end
  it 'should destroy the old gl with the correct activation' do
    @context_link.update_type(new_type)
    "Link::GlobalLink::#{old_type}GlobalLink".constantize.where(@gl_attrs)[0].try(:active).should == @state_hash[:old_global_link][:activation]
  end
  it 'should create the new gl with the correct counts' do
    @context_link.update_type(new_type)
    "Link::GlobalLink::#{new_type}GlobalLink".constantize.where(@gl_attrs)[0].try(:users_count).should == @state_hash[:new_global_link][:users_count]
  end
  it 'should create the new gl with the correct activation' do
    @context_link.update_type(new_type)
    "Link::GlobalLink::#{new_type}GlobalLink".constantize.where(@gl_attrs)[0].try(:active).should == @state_hash[:new_global_link][:activation]
  end
  it 'should have the correct votes on the gns' do
    @state_hash[:old_global_node_to].each do |key, value|
      @context_link.try(:global_node_to).try(:reload).try(key).should == value
    end
    @state_hash[:old_global_node_from].each do |key, value|
      @context_link.try(:global_node_from).try(:reload).try(key).should == value
    end
    @context_link = @context_link.update_type(new_type)
    @state_hash[:new_global_node_to].each do |key, value|
      @context_link.try(:global_node_to).try(:reload).try(key).should == value
    end
    @state_hash[:new_global_node_from].each do |key, value|
      @context_link.try(:global_node_from).try(:reload).try(key).should == value
    end
  end
  it 'should have the correct votes on the qns' do
    @state_hash[:old_question_node_to].each do |key, value|
      @context_link.try(:question_node_to).try(:reload).try(key).should == value
    end
    @state_hash[:old_question_node_from].each do |key, value|
      @context_link.try(:question_node_from).try(:reload).try(key).should == value
    end
    @context_link = @context_link.update_type(new_type)
    @state_hash[:new_question_node_to].each do |key, value|
      @context_link.try(:question_node_to).try(:reload).try(key).should == value
    end
    @state_hash[:new_question_node_from].each do |key, value|
      @context_link.try(:question_node_from).try(:reload).try(key).should == value
    end
  end
  it 'should have the correct votes on the uns' do
    @state_hash[:old_user_node_to].each do |key, value|
      @context_link.try(:user_node_to).try(:reload).try(key).should == value
    end
    @state_hash[:old_user_node_from].each do |key, value|
      @context_link.try(:user_node_from).try(:reload).try(key).should == value
    end
    @context_link = @context_link.update_type(new_type)
    @state_hash[:new_user_node_to].each do |key, value|
      @context_link.try(:user_node_to).try(:reload).try(key).should == value
    end
    @state_hash[:new_user_node_from].each do |key, value|
      @context_link.try(:user_node_from).try(:reload).try(key).should == value
    end
  end

end
