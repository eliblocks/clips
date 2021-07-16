class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:library]

  def library
    @videos = current_user.videos.unremoved
  end

  def index
    @users = User.all
  end

  def show
    @user_videos = @user.videos.viewable
  end

  def usage
    @top_uploaders = current_user.most_watched_uploaders(5, 30)
    @top_videos = current_user.most_watched_videos(5, 30)
  end

  def dashboard
    redirect_to new_video_path unless current_user.videos.any?
    @top_earning = current_user.most_earned_videos(5, 30)
  end
end
