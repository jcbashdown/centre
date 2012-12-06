shared_examples_for 'a controller setting nodes for the view' do |type, page|
  before do
    @klass = type.capitalize.constantize 
  end
  context 'when the question is set' do
    before do
      @existing_view_configuration = {
                                       :"#{type}s_question" => @question.id,
                                       :"#{type}s_user" => nil,
                                       :"#{type}s_query" => nil 
                                     }
      @existing_view_configuration.each do |key, value|
        if value
          session[key] = value
        end
      end
    end
    it 'should call search on the nodes for the question' do
      @klass.should_receive(:find_by_context).with({:question => @existing_view_configuration[:"#{type}s_question"],
                                                   :user => @existing_view_configuration[:"#{type}s_user"],
                                                   :query => @existing_view_configuration[:"#{type}s_query"],
                                                   :page => page})
      @klass.should_receive(:find_by_context).with({:question => @existing_view_configuration[:"#{type}s_question"],
                                                   :user => @existing_view_configuration[:"#{type}s_user"],
                                                   :page => page})
      get :index, {:page => page} if page
      get :index if page.blank?
    end
    context 'when the user is set' do
      before do
        @existing_view_configuration.merge!(:"#{type}s_user" => @user.id)
        @existing_view_configuration.each do |key, value|
          if value
            session[key] = value
          end
        end
      end
      it 'should call search on the nodes for the question and user' do
      @klass.should_receive(:find_by_context).with({:question => @existing_view_configuration[:"#{type}s_question"],
                                                   :user => @existing_view_configuration[:"#{type}s_user"],
                                                   :query => @existing_view_configuration[:"#{type}s_query"],
                                                   :page => page})
      @klass.should_receive(:find_by_context).with({:question => @existing_view_configuration[:"#{type}s_question"],
                                                   :user => @existing_view_configuration[:"#{type}s_user"],
                                                   :page => page})
        get :index, {:page => page} if page
        get :index if page.blank?
      end
      context 'when the query is set' do
        before do
          @existing_view_configuration.merge!(:"#{type}s_query" => @query)
          @existing_view_configuration.each do |key, value|
            if value
              session[key] = value
            end
          end
        end
        it 'should call search on the nodes for the question and user and query' do
          @klass.should_receive(:find_by_context).with({:question => @existing_view_configuration[:"#{type}s_question"],
                                                   :user => @existing_view_configuration[:"#{type}s_user"],
                                                   :query => @existing_view_configuration[:"#{type}s_query"],
                                                   :page => page})
          @klass.should_receive(:find_by_context).with({:question => @existing_view_configuration[:"#{type}s_question"],
                                                   :user => @existing_view_configuration[:"#{type}s_user"],
                                                   :page => page})
          get :index, {:page => page} if page
          get :index if page.blank?
        end
      end
    end
    context 'when the query is set' do
      before do
        @existing_view_configuration.merge!(:"#{type}s_query" => @query)
        @existing_view_configuration.each do |key, value|
          if value
            session[key] = value
          end
        end
      end
      it 'should call search on the nodes for the question and user and query' do
        @klass.should_receive(:find_by_context).with({:question => @existing_view_configuration[:"#{type}s_question"],
                                                   :user => @existing_view_configuration[:"#{type}s_user"],
                                                   :query => @existing_view_configuration[:"#{type}s_query"],
                                                   :page => page})
        @klass.should_receive(:find_by_context).with({:question => @existing_view_configuration[:"#{type}s_question"],
                                                   :user => @existing_view_configuration[:"#{type}s_user"],
                                                   :page => page})
        get :index, {:page => page} if page
        get :index if page.blank?
      end
    end
  end
  context 'when the user is set' do
    before do
      @existing_view_configuration = {
                                       :"#{type}s_user" => @user.id,
                                       :"#{type}s_question" => nil,
                                       :"#{type}s_query" => nil,
                                     }
      @existing_view_configuration.each do |key, value|
        if value
          session[key] = value
        end
      end
    end
    it 'should call search on the nodes for the user' do
      @klass.should_receive(:find_by_context).with({:question => @existing_view_configuration[:"#{type}s_question"],
                                                   :user => @existing_view_configuration[:"#{type}s_user"],
                                                   :query => @existing_view_configuration[:"#{type}s_query"],
                                                   :page => page})
      @klass.should_receive(:find_by_context).with({:question => @existing_view_configuration[:"#{type}s_question"],
                                                   :user => @existing_view_configuration[:"#{type}s_user"],
                                                   :page => page})
      get :index, {:page => page} if page
      get :index if page.blank?
    end
    context 'when the query is set' do
      before do
        @existing_view_configuration.merge!(:"#{type}s_query" => @query)
        @existing_view_configuration.each do |key, value|
          if value
            session[key] = value
          end
        end
      end
      it 'should call search on the nodes for the question and user and query' do
        @klass.should_receive(:find_by_context).with({:question => @existing_view_configuration[:"#{type}s_question"],
                                                   :user => @existing_view_configuration[:"#{type}s_user"],
                                                   :query => @existing_view_configuration[:"#{type}s_query"],
                                                   :page => page})
        @klass.should_receive(:find_by_context).with({:question => @existing_view_configuration[:"#{type}s_question"],
                                                   :user => @existing_view_configuration[:"#{type}s_user"],
                                                   :page => page})
        get :index, {:page => page} if page
        get :index if page.blank?
      end
    end
  end
  context 'when the query is set' do
    before do
      @existing_view_configuration = {
				       :"#{type}s_query" => @query,
                                       :"#{type}s_question" => nil,
                                       :"#{type}s_user" => nil,
                                     }
      @existing_view_configuration.each do |key, value|
        if value
          session[key] = value
        end
      end
    end
    it 'should call search on the nodes for the query' do
      @klass.should_receive(:find_by_context).with({:question => @existing_view_configuration[:"#{type}s_question"],
                                                   :user => @existing_view_configuration[:"#{type}s_user"],
                                                   :query => @existing_view_configuration[:"#{type}s_query"],
                                                   :page => page})
      @klass.should_receive(:find_by_context).with({:question => @existing_view_configuration[:"#{type}s_question"],
                                                   :user => @existing_view_configuration[:"#{type}s_user"],
                                                   :page => page})
      get :index, {:page => page} if page
      get :index if page.blank?
    end
  end
end
shared_examples_for 'a controller setting links for the view' do |direction, type, page|
  context 'when the question is set' do
    before do
      @existing_view_configuration = {
                                       :"#{type}s_#{direction}_question" => @question.id,
                                       :"#{type}s_#{direction}_user" => nil,
                                       :"#{type}s_#{direction}_query" => nil 
                                     }
      @existing_view_configuration.each do |key, value|
        if value
          session[key] = value
        end
      end
    end
    it 'should call search on the nodes for the question' do
      @current_node.should_receive(:"find_view_links_by_context").with(direction, {
                    :question => @existing_view_configuration[:"#{type}s_#{direction}_question"],
                    :user => @existing_view_configuration[:"#{type}s_#{direction}_user"],
                    :query => @existing_view_configuration[:"#{type}s_#{direction}_query"],
                    :page => page
                  })
      @current_node.should_receive(:"find_view_links_by_context").with(direction, {
                    :question => @existing_view_configuration[:"#{type}s_#{direction}_question"],
                    :user => @existing_view_configuration[:"#{type}s_#{direction}_user"],
                    :page => page
                  })
      get :index, {:page => page} if page
      get :index if page.blank?
    end
    context 'when the user is set' do
      before do
        @existing_view_configuration.merge!(:"#{type}s_#{direction}_#{direction}_user" => @user.id)
        @existing_view_configuration.each do |key, value|
          if value
            session[key] = value
          end
        end
      end
      it 'should call search on the nodes for the question and user' do
        @current_node.should_receive(:"find_view_links_by_context").with(direction, {
                      :question => @existing_view_configuration[:"#{type}s_#{direction}_question"],
                      :user => @existing_view_configuration[:"#{type}s_#{direction}_user"],
                      :query => @existing_view_configuration[:"#{type}s_#{direction}_query"],
                      :page => page
                    })
        @current_node.should_receive(:"find_view_links_by_context").with(direction, {
                      :question => @existing_view_configuration[:"#{type}s_#{direction}_question"],
                      :user => @existing_view_configuration[:"#{type}s_#{direction}_user"],
                      :page => page
                    })
        get :index, {:page => page} if page
        get :index if page.blank?
      end
      context 'when the query is set' do
        before do
          @existing_view_configuration.merge!(:"#{type}s_#{direction}_#{direction}_query" => @query)
          @existing_view_configuration.each do |key, value|
            if value
              session[key] = value
            end
          end
        end
        it 'should call search on the nodes for the question and user and query' do
          @current_node.should_receive(:"find_view_links_by_context").with(direction, {
                        :question => @existing_view_configuration[:"#{type}s_#{direction}_question"],
                        :user => @existing_view_configuration[:"#{type}s_#{direction}_user"],
                        :query => @existing_view_configuration[:"#{type}s_#{direction}_query"],
                        :page => page
                      })
          @current_node.should_receive(:"find_view_links_by_context").with(direction, {
                        :question => @existing_view_configuration[:"#{type}s_#{direction}_question"],
                        :user => @existing_view_configuration[:"#{type}s_#{direction}_user"],
                        :page => page
                      })
          get :index, {:page => page} if page
          get :index if page.blank?
        end
      end
    end
    context 'when the query is set' do
      before do
        @existing_view_configuration.merge!(:"#{type}s_#{direction}_#{direction}_query" => @query)
        @existing_view_configuration.each do |key, value|
          if value
            session[key] = value
          end
        end
      end
      it 'should call search on the nodes for the question and user and query' do
        @current_node.should_receive(:"find_view_links_by_context").with(direction, {
                      :question => @existing_view_configuration[:"#{type}s_#{direction}_question"],
                      :user => @existing_view_configuration[:"#{type}s_#{direction}_user"],
                      :query => @existing_view_configuration[:"#{type}s_#{direction}_query"],
                      :page => page
                    })
        @current_node.should_receive(:"find_view_links_by_context").with(direction, {
                      :question => @existing_view_configuration[:"#{type}s_#{direction}_question"],
                      :user => @existing_view_configuration[:"#{type}s_#{direction}_user"],
                      :page => page
                    })
        get :index, {:page => page} if page
        get :index if page.blank?
      end
    end
  end
  context 'when the user is set' do
    before do
      @existing_view_configuration = {
                                       :"#{type}s_#{direction}_#{direction}_user" => @user.id,
                                       :"#{type}s_#{direction}_#{direction}_question" => nil,
                                       :"#{type}s_#{direction}_#{direction}_query" => nil,
                                     }
      @existing_view_configuration.each do |key, value|
        if value
          session[key] = value
        end
      end
    end
    it 'should call search on the nodes for the user' do
      @current_node.should_receive(:"find_view_links_by_context").with(direction, {
                    :question => @existing_view_configuration[:"#{type}s_#{direction}_question"],
                    :user => @existing_view_configuration[:"#{type}s_#{direction}_user"],
                    :query => @existing_view_configuration[:"#{type}s_#{direction}_query"],
                    :page => page
                  })
      @current_node.should_receive(:"find_view_links_by_context").with(direction, {
                    :question => @existing_view_configuration[:"#{type}s_#{direction}_question"],
                    :user => @existing_view_configuration[:"#{type}s_#{direction}_user"],
                    :page => page
                  })
      get :index, {:page => page} if page
      get :index if page.blank?
    end
    context 'when the query is set' do
      before do
        @existing_view_configuration.merge!(:"#{type}s_#{direction}_#{direction}_query" => @query)
        @existing_view_configuration.each do |key, value|
          if value
            session[key] = value
          end
        end
      end
      it 'should call search on the nodes for the question and user and query' do
        @current_node.should_receive(:"find_view_links_by_context").with(direction, {
                      :question => @existing_view_configuration[:"#{type}s_#{direction}_question"],
                      :user => @existing_view_configuration[:"#{type}s_#{direction}_user"],
                      :query => @existing_view_configuration[:"#{type}s_#{direction}_query"],
                      :page => page
                    })
        @current_node.should_receive(:"find_view_links_by_context").with(direction, {
                      :question => @existing_view_configuration[:"#{type}s_#{direction}_question"],
                      :user => @existing_view_configuration[:"#{type}s_#{direction}_user"],
                      :page => page
                    })
        get :index, {:page => page} if page
        get :index if page.blank?
      end
    end
  end
  context 'when the query is set' do
    before do
      @existing_view_configuration = {
				       :"#{type}s_#{direction}_#{direction}_query" => @query,
                                       :"#{type}s_#{direction}_#{direction}_question" => nil,
                                       :"#{type}s_#{direction}_#{direction}_user" => nil,
                                     }
      @existing_view_configuration.each do |key, value|
        if value
          session[key] = value
        end
      end
    end
    it 'should call search on the nodes for the query' do
      @current_node.should_receive(:"find_view_links_by_context").with(direction, {
                    :question => @existing_view_configuration[:"#{type}s_#{direction}_question"],
                    :user => @existing_view_configuration[:"#{type}s_#{direction}_user"],
                    :query => @existing_view_configuration[:"#{type}s_#{direction}_query"],
                    :page => page
                  })
      @current_node.should_receive(:"find_view_links_by_context").with(direction, {
                    :question => @existing_view_configuration[:"#{type}s_#{direction}_question"],
                    :user => @existing_view_configuration[:"#{type}s_#{direction}_user"],
                    :page => page
                  })
      get :index, {:page => page} if page
      get :index if page.blank?
    end
  end
end
