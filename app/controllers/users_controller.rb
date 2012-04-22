class UsersController < ApplicationController
  layout 'sign_up'
  before_filter :authenticate_user!

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.all
  end

end

