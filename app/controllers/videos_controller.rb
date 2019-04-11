class VideosController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :set_video, only: [:show, :edit, :update, :destroy, :remove, :restore]
  before_action :redirect_to_root, only: [:new, :edit, :update, :destroy]

  def index
    @videos = Video.includes(:account)
    .featured
    .order(views: :desc, created_at: :desc)
    .page(params[:page])
    .per(15)
  end

  def show
    if user_signed_in?
      if @video.removed || @video.suspended
        render 'embeds/unavailable'
      end

      if current_user.account.balance < 10
        flash[:notice] = "You're out of minutes! Buy more to keep watching"
        session[:video_id] = @video.id
        session[:ref] = 'site'
        redirect_to new_charge_path()
      end
    end
  end

  def preview
  end

  def new
    @video = Video.new
  end

  def edit
    unless current_account == @video.account || current_user.admin?
      redirect_to root_url
    end
  end

  def create
    signed_url = params["video"]["storage_url"]
    @video = current_account.videos.new(
      title: params["video"]["title"],
      storage_url: signed_url.gsub(/\?.*/, ""),
      image: Rails.configuration.default_image
    )
    if @video.save
      ProbeVideoJob.perform_later(@video, signed_url)
      render json: @video.slice(:title), status: :created
    else
      render json: @video.errors.full_messages, status: :unprocessable_entity
    end
  end

  def update
    params_with_image = video_params
    if params[:image_id].present?
      preloaded = Cloudinary::PreloadedFile.new(params[:image_id])
      raise "Invalid upload signature" if !preloaded.valid?
      params_with_image.merge!(image: preloaded.identifier)
    end

    if @video.update(params_with_image)
      flash[:success] = "Video successfully updated"
      redirect_to library_path
    else
      render :edit
    end
  end

  def destroy
    if @video.plays.any?
      @video.remove
      flash[:success] = 'Video successfully removed.'
      redirect_to library_path
    elsif @video.destroy
      flash[:success] = 'Video successfully destroyed.'
      redirect_to library_path
    else
      render 'edit'
    end
  end

  def restore
    if @video.update(removed: false)
      flash[:success] = "Video successfully restored"
      redirect_to library_path
    else
      render 'edit'
    end
  end

  def search
    @videos = Video.viewable
    .search(params[:q], page: params[:page])
    render 'index'
  end

  private

    def redirect_to_root
      unless user_signed_in?
        redirect_to root_path
      end
    end

    def redirect_to_preview
      unless user_signed_in?
        redirect_to preview_video_path
      end
    end

    def set_video
      @video = Video.find(params[:id])
    end

    def video_params
      params.require(:video).permit(:title, :description, :duration, :price,
                    :approved, :clip, :balance, :views, :user_id, :imdb_id, :public)
    end

    def test_users
      test_uids = ["108116283341322", "113454752806178", "118849962265351", "102626340558548", "112712999547131"]
      @test_users = User.where(uid: test_uids)
      @test_users.select { |user| user.account.plays.last == nil ||
                                  user.account.plays.last.created_at < 2.minutes.ago }
    end
end
