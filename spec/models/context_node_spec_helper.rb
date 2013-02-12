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
    cn = (cn.is_a?(ContextNode) ? cn : cn.context_node_from)
    gn = Node::GlobalNode.where(:title => 'Title', :users_count => @state_hash[:global_node][:users_count])
    gn.count.should == 1
    gn[0].id.should == cn.global_node_id
    Node::GlobalNode.where(:title => 'Title').count.should == 1
  end
end
