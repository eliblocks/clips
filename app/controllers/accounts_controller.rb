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
    @account.clips.attach(params[:account][:clips]) if params[:account][:clips]
    if @account.update(account_params)
      flash[:success] = "Profile Successfully Updated"
      redirect_to user_path(@account.user)
    else
      render 'edit'
    end
  end

  def upload
  end

  def submitted_params
    params.require(:account).permit(:paypal_email, clips: [])
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
    redirect_to new_video_path unless current_account.videos.any?
    @top_earning = current_account.most_earned_videos(5, 30)
  end

end
