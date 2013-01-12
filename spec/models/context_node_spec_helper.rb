shared_examples_for 'context node creating nodes' do
  before do
    @state_hash = @node_state_hash
    @perform ||= 'ContextNode.create(@params)'
  end
  it 'should create the correct number of question_nodes' do
    expect {
      eval(@perform)
    }.to change(Node::QuestionNode, :count).by(@state_hash[:question_node][:number_created])
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
  it 'should create the correct number of user_nodes' do
    expect {
      eval(@perform)
    }.to change(Node::UserNode, :count).by(@state_hash[:user_node][:number_created])
  end
  it 'should create the correct question node with the correct users count' do
    cn = eval(@perform)
    cn = (cn.is_a?(ContextNode) ? cn : cn.context_node_from)
    qn = Node::QuestionNode.where(:title => 'Title', :question_id => @question.id, :users_count => @state_hash[:question_node][:users_count], :is_conclusion => @state_hash[:question_node][:is_conclusion])
    qn.count.should == 1
    qn[0].id.should == cn.question_node_id
    Node::QuestionNode.where(:title => 'Title').count == @state_hash[:question_node][:number_existing]
  end
  it 'should create the correct user node with the correct users count' do
    cn = eval(@perform)
    cn = (cn.is_a?(ContextNode) ? cn : cn.context_node_from)
    un = Node::UserNode.where(:title => 'Title', :user_id => @user.id, :users_count => @state_hash[:user_node][:users_count])
    un.count.should == 1
    un[0].id.should == cn.user_node_id
    Node::UserNode.where(:title => 'Title').count.should == @state_hash[:user_node][:number_existing]
  end
  it 'should create the correct global node with the correct users count' do
    cn = eval(@perform)
    cn = (cn.is_a?(ContextNode) ? cn : cn.context_node_from)
    gn = Node::GlobalNode.where(:title => 'Title', :users_count => @state_hash[:global_node][:users_count], :is_conclusion => @state_hash[:global_node][:is_conclusion])
    gn.count.should == 1
    gn[0].id.should == cn.global_node_id
    Node::GlobalNode.where(:title => 'Title').count.should == 1
  end
end
