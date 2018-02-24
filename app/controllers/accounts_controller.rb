class AccountsController < ApplicationController
  before_action :authenticate_facebook

  def edit
    @account = current_user.account
  end

  def show
    @top_earning = current_account.most_earned_videos(5, 30)
    @top_uploaders = current_account.most_watched_uploaders(5, 30)
    @top_videos = current_account.most_watched_videos(5, 30)
  end

  def update
    @account = current_user.account
    print account_params
    if @account.update(account_params)
      flash[:success] = "Profile Successfully Updated"
      redirect_to user_path(@account.user)
    else
      render 'edit'
    end
  end

  def submitted_params
    params.permit(:paypal_email)
  end

  def account_params
    if params[:image_id].present?
      preloaded = Cloudinary::PreloadedFile.new(params[:image_id])
      raise "Invalid upload signature" if !preloaded.valid?
      submitted_params.merge(image: preloaded.identifier)
    else
      submitted_params
    end
  end

  def usage
    @top_uploaders = current_account.most_watched_uploaders(5, 30)
    @top_videos = current_account.most_watched_videos(5, 30)
  end

  def dashboard
    redirect_to new_video_path unless current_user.videos.any?
    @top_earning = current_account.most_earned_videos(5, 30)
  end

end
