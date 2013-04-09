require 'spec_helper'
require 'lib/conclusion_spec_helper'

describe GroupQuestionConclusion do
  subject {GroupQuestionConclusion}

  describe ".search_context" do
    #also remove all the tries and properly stub

  end

  describe ".meets_criteria?" do

  end

  it_should_behave_like "a conclusion class extending conclusion", {:group_ids => [1, 2]}, {:group_ids => [1, 2]}
end
