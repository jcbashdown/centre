require 'spec_helper'
require 'controllers/links_controller_spec_helper'

describe LinksController do
  let(:current_user) {FactoryGirl.create(:user)}
  let(:direction) {"from"}
  let(:question) {FactoryGirl.create(:question)}
  let(:nodes_params) {{:global_link => {"global_node_from_id" => "1",
                                        "global_node_to_id" => "2"}}}
  before {controller.stub(:current_user).and_return current_user}

  describe 'update' do
    let(:id) {123321}
    let(:type) {"Positive"}
    let(:mock_link) {mock('link')}
    let(:mock_links) {[mock_link]}
    let(:mock_format) {mock('format')}
    let(:params) {{type: type, direction: direction, id: id}.merge(nodes_params)} 
    before do
      Link::UserLink.stub(:where).and_return mock_links
      mock_link.stub(:update_type).and_return mock_link
      mock_link.stub(:persisted?)
    end
    
    it_should_behave_like "a LinksController method with the set_link_question before filter", :put, :update, {:id => 1}

    context "with a @link_question set" do
      before do
        Question.stub(:find_by_id).and_return question
      end
      it "should call where on Link::UserLink with the params[:id] as the global_link_id and the current_user.id as the user_id" do
        Link::UserLink.should_receive(:where)
          .with(
                 user_id: current_user.id,
                 global_link_id: id.to_s
               )
          .and_return mock_links
        put :update, params
      end
      it "should call update_type on the the first result of where with the params[:type]" do
        mock_link.should_receive(:update_type).with type, question
        put :update, params
      end

    end

    it "should have node from and to or makes no sense?" do
      pending
    end

    it_should_behave_like "a LinksController method calling rerender_link to handle rendering", {:rest_action => :put, :method => :update}

  end
  describe 'create' do
    let(:type) {"Positive"}
    let(:mock_link) {mock('link')}
    let(:mock_format) {mock('format')}
    let(:params) {{type: type, direction: direction}.merge(nodes_params)} 
    before do
      "Link::UserLink::#{type}UserLink".constantize.stub(:create).and_return mock_link
      mock_link.stub(:persisted?)
    end

    it_should_behave_like "a LinksController method with the set_link_question before filter", :post, :create

    context "with a @link_question set" do
      before do
        Question.stub(:find_by_id).and_return question
      end
      it "should call create on the correct type of Link::UserLink with the global_link params the current_user.id as the user_id and the question.id as the question_id" do
        "Link::UserLink::#{type}UserLink".constantize.should_receive(:create)
          .with( params[:global_link].merge("question_id" => question.id, "user_id" => current_user.id))
          .and_return mock_link
        post :create, params
      end
    end

    it_should_behave_like "a LinksController method calling rerender_link to handle rendering", {:rest_action => :post, :method => :create}

  end
  describe 'destroy' do
    let(:id) {123321}
    let(:type) {"Positive"}
    let(:mock_link) {mock('link')}
    let(:mock_links) {[mock_link]}
    let(:mock_format) {mock('format')}
    let(:params) {{type: type, direction: direction, id: id}.merge(nodes_params)} 
    before do
      mock_link.stub(:persisted?).and_return false
      mock_link.stub(:destroy).and_return mock_link
      Link::UserLink.stub(:where).and_return mock_links
    end

    it_should_behave_like "a LinksController method with the set_link_question before filter", :delete, :destroy, {:id => 1}

    context "with a @link_question set" do
      before do
        Question.stub(:find_by_id).and_return question
      end
      it "should call where on Link::UserLink with the params[:id] as the global_link_id and the current_user.id as the user_id" do
        Link::UserLink.should_receive(:where)
          .with(
                 user_id: current_user.id,
                 global_link_id: id.to_s
               )
          .and_return mock_links
        delete :destroy, params
      end
      it "should call destroy on the mock_link" do
        mock_link.should_receive(:destroy)
        delete :destroy, params
      end
    end

    it_should_behave_like "a LinksController method calling rerender_link to handle rendering", {:rest_action => :delete, :method => :destroy}
  end

end
