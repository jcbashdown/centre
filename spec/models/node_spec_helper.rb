shared_examples_for 'a node finding directed links' do |direction, this_node|
  context 'when the question is set' do
    before do
      @links = {}
      @users.each_with_index do |user, iu|
        @questions.each_with_index do |question, iq|
          @context_nodes.each do |cn|
            @queries.each do |query|
              if cn.title =~ Regexp.new(query)
                @links[:"user#{iu}_question#{iq}_#{query}"] = 
                  ContextLink::PositiveContextLink.create!(:user=>user, :question => question, :"global_node_#{direction}_id" => cn.global_node.id, :"global_node_#{this_node}_id" => @node.id).global_link        
              end
            end
          end
        end
      end
      @users << nil
      @questions << nil
    end
    it 'should find the correct links for each context' do
      p @links
      @users.each_with_index do |user, iu|
        @questions.each_with_index do |question, iq|
          @queries.each do |query|
            p @node.find_view_links_by_context(direction, this_node, {:user => user.id, :question => question.id, :query => query})
            @node.find_view_links_by_context(direction, this_node, {:user => user.id, :question => question.id, :query => query}).should == [@links[:"user#{iu}_question#{iq}_#{query}"]]
          end
        end
      end
    end
  end
end
