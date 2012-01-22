
require 'spec_helper'

describe ApplicationController do

  describe "set current user" do
    before do
      @user = Factory(:user)
      @controller.stub(:current_user).and_return @user
    end
    it "assigns the user" do
      @controller.set_current_user
      assigns(:user).should == @user
    end
  end

end
