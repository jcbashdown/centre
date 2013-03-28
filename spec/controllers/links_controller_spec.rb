require 'spec_helper'

describe LinksController do
  let(:current_user) {Factory(:user)}
  let(:direction) {"from"}
  let(:question) {Factory(:question)}
  before {controller.stub(:current_user).and_return current_user}

  shared_examples_for "a LinksController method with the set_link_question before filter" do

  end

  shared_examples_for "a LinksController method calling rerender_link to handle rendering" do

    shared_examples_for "a rerendered_link which does not correspond to a persisted link" do
      
      #includes how place holder link is built through params - integration test, could do unit test but beginning to feel slightly fishy...

    end

    shared_examples_for "a rerendered_link which is persisted" do

    end

    context "when the user link is not nil" do

      context "and the user link is persisted" do

      end

      context "and the user link is not persisted" do

      end

    end

    context "when the user link is nil" do

    end
  end

  describe 'update' do
    let(:id) {123321}
    let(:type) {"Positive"}
    let(:mock_link) {mock('link')}
    let(:mock_links) {[mock_link]}
    let(:params) {{type: type, direction: direction, id: id}} 
    before do
      mock_link.stub(:update_type)
      mock_link.stub(:persisted?)
    end

    context "with a @link_question set" do
      before {Question.stub(:find_by_id).and_return question}
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
        Link::UserLink.stub(:where).and_return mock_links
        mock_link.should_receive(:update_type).with type, question
        put :update, params
      end

    end
  end
  describe 'create' do

  end
  describe 'destroy' do

  end

end
