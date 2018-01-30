class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:library]
  def library
    @videos = current_user.videos.unremoved
  end

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @user_videos = @user.videos.viewable
  end

end
