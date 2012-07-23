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
    context_link.question_link.active.should == @state_hash[:question_link][:activation]
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
    context_link.user_link.active.should == @state_hash[:user_link][:activation]
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
    context_link.global_link.active.should == @state_hash[:global_link][:activation]
  end
  it 'should create the correct number of context nodes' do
    ContextNode.should_receive(:find_or_create_by_user_id_and_question_id_and_title).exactly(@state_hash[:context_node][:number_created]).times.and_return @gnu1
    "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
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
#shared_examples_for 'a context_link deleting links' do |type, @state_hash|
#
#end
