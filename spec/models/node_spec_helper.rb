shared_examples_for 'a node finding directed links' do |direction, this_node|
  context 'when the question is set' do
    before do
      @links = {}
      @users.each_with_index do |user, iu|
        @questions.each_with_index do |question, iq|
          @context_nodes.each do |cn|
            @queries.each do |query|
              if cn.title =~ Regexp.new(query, true)
                all_key = :"user#{iu}_question#{iq}_#{query}"
                params = {:user_id =>user.id, :question_id => question.id, :"global_node_#{direction}_id" => cn.global_node.id, :"global_node_#{this_node}_id" => @node.id}
                new_gn = ContextLink::PositiveContextLink.where(params)[0].try(:global_link) || ContextLink::PositiveContextLink.create!(params).global_link
                if new_gn
                  if @links[all_key]
                    @links[all_key][new_gn.id] = new_gn
                  else
                    @links[all_key] = {new_gn.id => new_gn}
                  end
                end
                question_key = :"question#{iq}_#{query}"
                if new_gn
                  if @links[question_key]
                    @links[question_key][new_gn.id] = new_gn
                  else
                    @links[question_key] = {new_gn.id => new_gn}
                  end
                end

                user_key = :"user#{iu}_#{query}"
                if new_gn
                  if @links[user_key]
                    @links[user_key][new_gn.id] = new_gn
                  else
                    @links[user_key] = {new_gn.id => new_gn}
                  end
                end
              end
            end
          end
        end
      end
      @users << nil
      @questions << nil
    end
    it 'should find the correct links for each context' do
      @users.each_with_index do |user, iu|
        @questions.each_with_index do |question, iq|
          @queries.each do |query|
            @node.find_view_links_by_context(direction, this_node, {:user => user.try(:id), :question => question.try(:id), :query => query}).each do |gn|
              if user && question
                @links[:"user#{iu}_question#{iq}_#{query}"][gn.id].should == gn 
              elsif user
                @links[:"user#{iu}_#{query}"][gn.id].should == gn
              elsif question
                if (link = @links[:"question#{iq}_#{query}"][gn.id]).try(:persisted?)
                  link.should == gn
                else
                  gn.should be_a Link::GlobalLink
                  gn.send(:"node_#{this_node}_id").should == @node.id
                end
              end
            end
          end
        end
      end
    end
  end
end
