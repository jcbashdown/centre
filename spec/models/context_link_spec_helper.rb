shared_examples_for 'a context link creating links' do |type, counts_hash|
  it 'should create the correct number of context links' do
    expect {
      "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    }.to change(ContextLink, :count).by(counts_hash[:context_link][:number_created])
  end
  it 'should create the correct number of the correct context links' do
    expect {
      "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    }.to change("ContextLink::#{type}ContextLink".constantize, :count).by(counts_hash[:context_link][:number_created])
  end
  it 'should create the correct number of question links' do
    expect {
      "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    }.to change(Link::QuestionLink, :count).by(counts_hash[:question_link][:number_created])
  end
  it 'should create the correct number of the correct question links' do
    expect {
      "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    }.to change("Link::QuestionLink::#{type}QuestionLink".contantize, :count).by(counts_hash[:question_link][:number_created])
  end
  it 'should create the ql with the correct counts' do
    context_link = "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    context_link.question_link.users_count.should == counts_hash[:question_link][:users_count]
  end
  it 'should create the ql with the correct activation' do
    context_link = "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    context_link.question_link.active.should == counts_hash[:question_link][:activation]
  end
  it 'should create the correct number of uls' do
    expect {
      "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    }.to change(Link::UserLink, :count).by(counts_hash[:user_link][:number_created])
  end
  it 'should create the correct number of the correct uls' do
    expect {
      "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    }.to change("Link::UserLink::#{Positive}UserLink".constantize, :count).by(counts_hash[:user_link][:number_created])
  end
  it 'should create the ul with the correct counts' do
    context_link = "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    context_link.user_link.users_count.should == counts_hash[:user_link][:users_count]
  end
  it 'should create the ul with the correct activation' do
    context_link = "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    context_link.user_link.active.should == counts_hash[:user_link][:activation]
  end
  it 'should create the correct number of gls' do
    expect {
      "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    }.to change(Link::GlobalLink, :count).by(counts_hash[:global_link][:number_created])
  end
  it 'should create the correct number of the correct gls' do
    expect {
      "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    }.to change("Link::GlobalLink::#{Positive}GlobalLink".constantize, :count).by(counts_hash[:global_link][:number_created])
  end
  it 'should create the gl with the correct counts' do
    context_link = "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    context_link.global_link.users_count.should == counts_hash[:global_link][:users_count]
  end
  it 'should create the gl with the correct activation' do
    context_link = "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    context_link.global_link.active.should == counts_hash[:global_link][:activation]
  end
  it 'should create the correct number of context nodes' do
    context_link = "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    ContextNode.should_receive(:create).exactly(counts_hash[:context_node][:number_created]).times
  end
  it 'should have persisted gnus to and from' do
    context_link = "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    context_link.context_node_from.should be_persisted
    context_link.context_node_to.should be_persisted
  end
  it 'should have the correct votes on the gns' do
    context_link = "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    context_link.global_link.global_node_to.upvotes_count.should == counts_hash[:new_global_node_to][:upvotes_count]
    context_link.global_link.global_node_from.upvotes_count.should == counts_hash[:new_global_node_from][:upvotes_count] 
  end
  it 'should have the correct votes on the qns' do
    context_link = "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    context_link.question_link.question_node_to.upvotes_count.should == counts_hash[:new_question_node_to][:upvotes_count]
    context_link.question_link.question_node_from.upvotes_count.should == counts_hash[:new_question_node_from][:upvotes_count]
  end
  it 'should register the vote on nu' do
    "ContextLink::#{type}ContextLink".constantize.create(:user=>@user, :question => @question, :global_node_from_id => @gnu1.global_node.id, :global_node_to_id => @gnu2.global_node.id)
    node_to = Node::UserNode.where(:node_title_id => @gnu2.node_title_id, :user_id => @user.id)[0]
    node_to.upvotes_count.should == 1
    node_from = Node::UserNode.where(:node_title_id => @gnu1.node_title_id, :user_id => @user.id)[0]
    node_from.should_not be_nil
    node_from.upvotes_count.should == 0 
  end
end
shared_examples_for 'a context_link updating links' do |type, counts_hash|

end
shared_examples_for 'a context_link deleting links' do |type, counts_hash|

end
