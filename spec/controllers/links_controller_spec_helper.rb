shared_examples_for "a LinksController method with the set_link_question before filter" do |rest_action, method, essential_params={}|
  before do
    controller.stub(method)
    controller.stub(:render)
  end
  
  it "should call find_by_id on Question and assign the result to @link_question" do
    Question.should_receive(:find_by_id).with nil
    send(rest_action, method, essential_params)
    assigns(:link_question).should == nil
    controller.session[:links_question] = question.id
    Question.should_receive(:find_by_id).with(question.id).and_return question
    send(rest_action, method, essential_params)
    assigns(:link_question).should == question
  end

  context "when there is a valid links_question in the session" do
    before {controller.session[:links_question] = question.id}
    it "should assign a real Question to @link_question" do
      send(rest_action, method, essential_params)
      assigns(:link_question).should be_a Question
      assigns(:link_question).should be_persisted
    end
  end

  context "when there is not a valid links question in the session" do
    it "should assign nil to @link_question" do
      send(rest_action, method, essential_params)
      assigns(:link_question).should be_nil
    end
  end

end

shared_examples_for "a LinksController method calling rerender_link to handle rendering" do |call_details|
  let(:correct_user_link) {mock_link}

  before do
    controller.stub(:render)
  end

  it "should call rerender_link with the correct_user_link and the mock_format" do
    controller.stub(:respond_to).and_yield mock_format
    controller.should_receive(:rerender_link).with correct_user_link, mock_format
    send(call_details[:rest_action], call_details[:method], params)
  end

  context "when the user link is not nil" do

    context "and the user link is persisted" do
      before {correct_user_link.stub(:persisted?).and_return true}
      it_should_behave_like "a rerendered_link which is persisted", call_details

    end

    context "and the user link is not persisted" do
      it_should_behave_like "a rerendered_link which does not correspond to a persisted link", call_details
    end

  end

  context "when the user link is nil" do
    it_should_behave_like "a rerendered_link which does not correspond to a persisted link", call_details
  end
end

shared_examples_for "a rerendered_link which is persisted" do |call_details|
  context "when the format is .js" do
    let(:params_js) {params.merge(format: "js")}
    it "should render the 'a_link' partial with link:correct_user_link and direction:direction" do
      controller.should_receive(:render).with({
                                                partial: 'a_link', 
                                                locals: {
                                                          link: correct_user_link, 
                                                          direction: params_js[:direction]
                                                        } 
                                             })
      send(call_details[:rest_action], call_details[:method], params_js)
    end
  end
  context "when ther format is .json" do
    let(:params_json) {params.merge(format: "json")}
    let(:link_json) {{some: "json"}.to_json}
    before {correct_user_link.stub(:to_json).and_return link_json}
    it "should render the the user_link to_json" do
      controller.should_receive(:render).with({
                                                json: correct_user_link.to_json, 
                                             })
      send(call_details[:rest_action], call_details[:method], params_json)
    end
  end
end

shared_examples_for "a rerendered_link which does not correspond to a persisted link" do |call_details|
  let(:place_holder_link) {Link::GlobalLink.new(params[:global_link])}

  before {@place_holder_link = place_holder_link}

  context "when the format is .js" do
    let(:params_js) {params.merge(format: "js")}

    it "should render the 'a_link' partial with link:place_holder_link and direction:direction" do
      Link::GlobalLink.should_receive(:new).with(params[:global_link]).and_return @place_holder_link
      controller.should_receive(:render).with({
                                                partial: 'a_link', 
                                                locals: {
                                                          link: @place_holder_link, 
                                                          direction: params_js[:direction]
                                                        } 
                                             })
      send(call_details[:rest_action], call_details[:method], params_js)
    end
  end
  context "when ther format is .json" do
    let(:params_json) {params.merge(format: "json")}
    let(:place_holder_json) {place_holder_link.to_json}
    before {place_holder_link.stub(:to_json).and_return place_holder_json}

    it "should render the place_holder_link.to_json" do
      Link::GlobalLink.should_receive(:new).with(params[:global_link]).and_return place_holder_link
      controller.should_receive(:render).with({
                                                json: place_holder_json
                                             })
      send(call_details[:rest_action], call_details[:method], params_json)
    end
  end
end
