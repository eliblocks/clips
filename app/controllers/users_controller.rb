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

  def edit
    @account = current_user.account
  end

  # def show
  #   @top_earning = current_user.most_earned_videos(5, 30)
  #   @top_uploaders = current_user.most_watched_uploaders(5, 30)
  #   @top_videos = current_user.most_watched_videos(5, 30)
  # end

  def update
    binding.pry
    @account = current_user.account
    if @account.update(account_params)
      flash[:success] = "Profile Successfully Updated"
      redirect_to user_path(@account.user)
    else
      render 'edit'
    end
  end

  def upload
  end

  def account_params
    params.require(:account).permit(:paypal_email, :image)
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
