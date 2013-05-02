require 'spec_helper'
require 'lib/conclusion_spec_helper'

describe QuestionConclusion do
  subject {QuestionConclusion}
  it_should_behave_like "a conclusion class extending conclusion"
end
