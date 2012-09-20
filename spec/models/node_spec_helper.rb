shared_examples_for 'a node finding directed links' do |direction|
  context 'when the question is set' do
    before do
      @existing_view_configuration = {
                                       :question => @question.id,
                                       :user => nil,
                                       :query => nil 
                                     }
    end
    it 'should return the correct question nodes' do
      Node.find_by_context(@existing_view_configuration).should == [@context_node1.global_node, @context_node3.global_node]
    end
    context 'when the user is set' do
      before do
        @existing_view_configuration.merge!(:user => @user.id)
      end
      it 'should return the correct context nodes' do
        Node.find_by_context(@existing_view_configuration).should == [@context_node1.global_node]
      end
      context 'when the query is set' do
        before do
          @existing_view_configuration.merge!(:query => @query)
        end
        it 'should return the correct context nodes' do
          Node.find_by_context(@existing_view_configuration).should == [@context_node1.global_node]
        end
      end
    end
    context 'when the query is set' do
      before do
        @existing_view_configuration.merge!(:query => @query)
      end
      it 'should return the correct question nodes' do
        Node.find_by_context(@existing_view_configuration).should == [@context_node1.global_node, @context_node3.global_node]
      end
    end
  end
  context 'when the user is set' do
    before do
      @existing_view_configuration = {
                                       :user => @user.id,
                                       :question => nil,
                                       :query => nil
                                     }
    end
    it 'should return the correct user nodes' do
      Node.find_by_context(@existing_view_configuration).should == [@context_node1.global_node, @context_node4.global_node]
    end
    context 'when the query is set' do
      before do
        @existing_view_configuration.merge!(:query => @query)
      end
      it 'should return the correct user nodes' do
        Node.find_by_context(@existing_view_configuration).should == [@context_node1.global_node]
      end
    end
  end
  context 'when the query is set' do
    before do
      @existing_view_configuration = {
					 :query => @query,
                                       :question => nil,
                                       :user => nil
                                     }
    end
    it 'should return the correct global nodes' do
      Node.find_by_context(@existing_view_configuration).should == [@context_node1.global_node, @context_node3.global_node]
    end
  end
end
