describe Node do
  describe 'set_nodes' do
    controller do
      before_filter :set_nodes
      def index 
        render :nothing => true
      end
    end
    before do
      @user = FactoryGirl.create(:user)
      @question = FactoryGirl.create(:question)
      @query = "Part of a node title"
    end
    context 'when the question is set' do
      before do
        @existing_view_configuration = {
                                         :nodes_question => @question.id,
                                         :nodes_user => nil,
                                         :nodes_query => nil 
                                       }
        @existing_view_configuration.each do |key, value|
          if value
            request.cookies[key] = value.to_s
          end
        end
      end
      it 'should call search on the nodes for the question' do
        Node.should_receive(:search).with @existing_view_configuration
        get :index
      end
      context 'when the user is set' do
        before do
          @existing_view_configuration.merge!(:nodes_user => @user.id)
          @existing_view_configuration.each do |key, value|
            if value
              request.cookies[key] = value.to_s
            end
          end
        end
        it 'should call search on the nodes for the question and user' do
          Node.should_receive(:search).with @existing_view_configuration
          get :index
        end
        context 'when the query is set' do
          before do
            @existing_view_configuration.merge!(:nodes_query => @query)
            @existing_view_configuration.each do |key, value|
              if value
                request.cookies[key] = value.to_s
              end
            end
          end
          it 'should call search on the nodes for the question and user and query' do
            Node.should_receive(:search).with @existing_view_configuration
            get :index
          end
        end
      end
      context 'when the query is set' do
        before do
          @existing_view_configuration.merge!(:nodes_query => @query)
          @existing_view_configuration.each do |key, value|
            if value
              request.cookies[key] = value.to_s
            end
          end
        end
        it 'should call search on the nodes for the question and user and query' do
          Node.should_receive(:search).with @existing_view_configuration
          get :index
        end
      end
    end
    context 'when the user is set' do
      before do
        @existing_view_configuration = {
                                         :nodes_user => @user.id,
                                         :nodes_question => nil,
                                         :nodes_query => nil,
                                       }
        @existing_view_configuration.each do |key, value|
          if value
            request.cookies[key] = value.to_s
          end
        end
      end
      it 'should call search on the nodes for the user' do
        Node.should_receive(:search).with @existing_view_configuration
        get :index
      end
      context 'when the query is set' do
        before do
          @existing_view_configuration.merge!(:nodes_query => @query)
          @existing_view_configuration.each do |key, value|
            if value
              request.cookies[key] = value.to_s
            end
          end
        end
        it 'should call search on the nodes for the question and user and query' do
          Node.should_receive(:search).with @existing_view_configuration
          get :index
        end
      end
    end
    context 'when the query is set' do
      before do
        @existing_view_configuration = {
					 :nodes_query => @query,
                                         :nodes_question => nil,
                                         :nodes_user => nil,
                                       }
        @existing_view_configuration.each do |key, value|
          if value
            request.cookies[key] = value.to_s
          end
        end
      end
      it 'should call search on the nodes for the query' do
        Node.should_receive(:search).with @existing_view_configuration
        get :index
      end
    end
  end
end
