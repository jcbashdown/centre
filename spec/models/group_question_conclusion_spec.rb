require 'spec_helper'
require 'lib/conclusion_spec_helper'

describe GroupQuestionConclusion do
  subject {GroupQuestionConclusion}
  it_should_behave_like "a conclusion class extending conclusion", {:group_ids => [1]}, {:group_id => 1}
end
