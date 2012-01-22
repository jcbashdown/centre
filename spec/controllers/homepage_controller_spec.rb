require 'spec_helper'

describe HomepageController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
    it "assigns the user" do
      get 'index'
      assigns(:user).should == @user
    end
  end

end
