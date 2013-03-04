shared_examples_for "a conclusion class extending conclusion" do |special_context, inferred_context|
  
  describe ".update_conclusion_status_for" do
    before do
      subject.stub(:votes_for_conclusion).and_return 0
      subject.stub(:votes_against_conclusion).and_return 0
      subject.stub(:find_or_create_conclusion)
      subject.stub(:destroy_conclusion_if_exists)
    end
    context "when there are more votes for conclusion than against" do
      before do
        subject.stub(:votes_for_conclusion).and_return 1
        subject.stub(:votes_against_conclusion).and_return 0
      end

    end
    context "when there the same number of votes for and against conclusion" do
      before do
        subject.stub(:votes_for_conclusion).and_return 0
        subject.stub(:votes_against_conclusion).and_return 0
      end

    end
    context "when there are more votes against conclusion than for" do
      before do
        subject.stub(:votes_for_conclusion).and_return 0
        subject.stub(:votes_against_conclusion).and_return 1
      end

    end
  end
  describe ".set_context" do
    let(:context) {special_context ? {:silly => "context"}.merge(special_context) : {:silly => "context"}}
    it "should assign context to the class instance variable @context" do
      subject.send(:set_context!, context)
      subject.instance_variable_get("@context").should == (inferred_context ? context.merge(inferred_context) : context)
    end
  end
end
