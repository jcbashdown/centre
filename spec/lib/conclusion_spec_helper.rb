shared_examples_for "a conclusion class extending conclusion" do |special_context, inferred_context|
  
  let(:context) {special_context ? {:silly => "context"}.merge(special_context) : {:silly => "context"}}

  describe ".update_conclusion_status_for" do
    let(:create_context) {context}
    before do
      subject.stub(:set_context!)
      subject.stub(:votes_for_conclusion).and_return 0
      subject.stub(:votes_against_conclusion).and_return 0
      subject.stub(:find_or_create_conclusion)
      subject.stub(:destroy_conclusion_if_exists)
      subject.stub(:create_context).and_return create_context
    end
    it 'should call set_context! with context' do
      subject.should_receive(:set_context!).with context
      subject.update_conclusion_status_for context
    end 
    context "when there are more votes for conclusion than against" do
      before do
        subject.stub(:votes_for_conclusion).and_return 1
        subject.stub(:votes_against_conclusion).and_return 0
      end
      it "should call create_conclusion_unless_exists with the result of create context" do
        subject.should_receive(:create_conclusion_unless_exists).with create_context
        subject.update_conclusion_status_for context
      end
    end
    context "when there the same number of votes for and against conclusion" do
      before do
        subject.stub(:votes_for_conclusion).and_return 0
        subject.stub(:votes_against_conclusion).and_return 0
      end
      it "should call destroy_conclusion_if_exists with the result of create context" do
        subject.should_receive(:destroy_conclusion_if_exists).with create_context
        subject.update_conclusion_status_for context
      end
    end
    context "when there are more votes against conclusion than for" do
      before do
        subject.stub(:votes_for_conclusion).and_return 0
        subject.stub(:votes_against_conclusion).and_return 1
      end
      it "should call destroy_conclusion_if_exists with the result of create context" do
        subject.should_receive(:destroy_conclusion_if_exists).with create_context
        subject.update_conclusion_status_for context
      end
    end
  end

  describe ".votes_for_conclusion" do
    it "should call vote_count with true" do
      subject.should_receive(:vote_count).with true
      subject.send(:votes_for_conclusion)
    end
  end

  describe ".votes_for_conclusion" do
    it "should call vote_count with false" do
      subject.should_receive(:vote_count).with false
      subject.send(:votes_against_conclusion)
    end
  end

  describe ".vote_count" do
    let(:conclusion_status) {true}
    let(:search_context) {{:search => "context"}}
    before {subject.stub(:search_context).and_return search_context}
    it 'should count the votes for the conclusion status' do
      mock_relation = mock('relation')
      ContextNode.should_receive(:where).with(search_context.merge(:is_conclusion => conclusion_status)).and_return mock_relation
      mock_relation.should_receive(:count)
      subject.send(:vote_count, conclusion_status)
    end
  end

  describe ".create_context" do

  end

  describe ".search_context" do

  end

  describe ".set_context" do
    it "should assign context to the class instance variable @context" do
      subject.send(:set_context!, context)
      subject.instance_variable_get("@context").should == (inferred_context ? context.merge(inferred_context) : context)
    end
  end
end
