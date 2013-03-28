require 'spec_helper'

describe LinksController do

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

  end
  describe 'create' do

  end
  describe 'destroy' do

  end

end
