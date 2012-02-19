require 'spec_helper'

describe LinksController do

  # This should return the minimal set of attributes required to create a valid
  # Link. As you add validations to Link, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

  describe 'update' do
    context 'when ajax request' do
      #get all node for page ordered by link params, if exists for user get otherwise new, get votes count separately - make sure onlythree of each node then user counts
      #deal with current user and update if new - don't create for each user
    end

  end
  describe 'create' do
    context 'when ajax request' do

    end

  end
  describe 'destroy' do
    context 'when ajax request' do

    end
  end
end
