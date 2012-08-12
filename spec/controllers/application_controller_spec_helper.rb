shared_examples_for 'a controller setting nodes or links for the view' do |type, page|
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
          request.cookies[key] = value.to_s
        end
      end
    end
    it 'should call search on the nodes for the question' do
      @klass.should_receive(:find_by_context).with @existing_view_configuration.merge(:page => page)
      get :index, {:page => page} if page
      get :index if page.blank?
    end
    context 'when the user is set' do
      before do
        @existing_view_configuration.merge!(:"#{type}s_user" => @user.id)
        @existing_view_configuration.each do |key, value|
          if value
            request.cookies[key] = value.to_s
          end
        end
      end
      it 'should call search on the nodes for the question and user' do
        @klass.should_receive(:find_by_context).with @existing_view_configuration.merge(:page => page)
        get :index, {:page => page} if page
        get :index if page.blank?
      end
      context 'when the query is set' do
        before do
          @existing_view_configuration.merge!(:"#{type}s_query" => @query)
          @existing_view_configuration.each do |key, value|
            if value
              request.cookies[key] = value.to_s
            end
          end
        end
        it 'should call search on the nodes for the question and user and query' do
          @klass.should_receive(:find_by_context).with @existing_view_configuration.merge(:page => page)
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
            request.cookies[key] = value.to_s
          end
        end
      end
      it 'should call search on the nodes for the question and user and query' do
        @klass.should_receive(:find_by_context).with @existing_view_configuration.merge(:page => page)
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
          request.cookies[key] = value.to_s
        end
      end
    end
    it 'should call search on the nodes for the user' do
      @klass.should_receive(:find_by_context).with @existing_view_configuration.merge(:page => page)
      get :index, {:page => page} if page
      get :index if page.blank?
    end
    context 'when the query is set' do
      before do
        @existing_view_configuration.merge!(:"#{type}s_query" => @query)
        @existing_view_configuration.each do |key, value|
          if value
            request.cookies[key] = value.to_s
          end
        end
      end
      it 'should call search on the nodes for the question and user and query' do
        @klass.should_receive(:find_by_context).with @existing_view_configuration.merge(:page => page)
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
          request.cookies[key] = value.to_s
        end
      end
    end
    it 'should call search on the nodes for the query' do
      @klass.should_receive(:find_by_context).with @existing_view_configuration.merge(:page => page)
      get :index, {:page => page} if page
      get :index if page.blank?
    end
  end
end
