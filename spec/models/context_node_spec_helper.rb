shared_examples_for 'context node creating nodes' do |type|
  it 'should create the correct number of question_nodes' do
    expect {
      ContextNode.create(:user=>@user, :question=>@question, :title => 'Title')
    }.to change(Node::QuestionNode, :count).by(1)
  end
  it 'should create the correct number of global_nodes' do
    expect {
      ContextNode.create(:user=>@user, :question=>@question, :title => 'Title')
    }.to change(Node::GlobalNode, :count).by(1)
  end
  it 'should create the correct number of context_nodes' do
    expect {
      ContextNode.create(:user=>@user, :question=>@question, :title => 'Title')
    }.to change(ContextNode, :count).by(1)
  end
  it 'should create the correct number of user_nodes' do
    expect {
      ContextNode.create(:user=>@user, :question=>@question, :title => 'Title')
    }.to change(Node::UserNode, :count).by(1)
  end
  #when correct question node etc this means rels are also correct in created context nodes - ids are right, include is conclusion status for each too
  it 'should create the correct question node with the correct users count' do
    cn = ContextNode.create(:user=>@user, :question=>@question, :title => 'Title')
    QuestionNode.where(:id => cn.question_node_id, :title => 'Title', :question => @question, :users_count => @state_hash[:question_node][:users_count])).count.should == @state_hash[:question_link][:number_created]
  end
  it 'should create the correct user node with the correct users count' do

  end
  it 'should create the correct global node with the correct users count' do

  end
  it 'should create a questions_node for the question and node and all and node' do
    context_node = ContextNode.create(:user=>@user, :question=>@question, :title => 'Title')
    context_node2 = ContextNode.create(:user=>@user, :question=>@question2, :title => 'Title')
    nu = context_node.user_node
    nu2 = context_node2.user_node
    nu.should_not be_nil
    nu2.should_not be_nil
    nu.should == nu2
    nu.reload.users_count.should == 2 
  end
  it 'should create a questions_node for the question and node and all and node' do
    context_node = ContextNode.create(:user=>@user, :question=>@question, :title => 'Title')
    context_node2 = ContextNode.create(:user=>@user, :question=>@question2, :title => 'Title')
    qn = context_node.question_node
    qn2 = context_node2.question_node
    qn.should_not be_nil
    qn2.should_not be_nil
    qn.should_not == qn2
    qn.reload.users_count.should == 1 
    qn2.reload.users_count.should == 1 
  end
end
