class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy, :remove, :restore, :preview]
  before_action :redirect_to_sign_in, only: [:new, :edit, :update, :destroy]
  before_action :redirect_to_preview, only: [:show]

  # GET /videos
  # GET /videos.json
  def index
    @videos = Video.includes(:user)
    .featured
    .order(views: :desc, created_at: :desc)
    .page(params[:page])
    .per(12)
    @test_users = test_users
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
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

  def preview
  end

  # GET /videos/new
  def new
    @video = Video.new
  end

  # GET /videos/1/edit
  def edit
    unless current_user == @video.user || current_user.admin?
      redirect_to root_url
    end
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(video_params)
    @video.user = current_user
    @video.image = Rails.configuration.default_image
    if @video.save
      puts "Success!"
    else
      puts "Fail: #{@video.error.full_messages}"
    end
    head :ok
  end

  # PATCH/PUT /videos/1
  # PATCH/PUT /videos/1.json
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

  # DELETE /videos/1
  # DELETE /videos/1.json
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

    def redirect_to_sign_in
      unless user_signed_in?
        redirect_to root_path
      end
    end

    def redirect_to_preview
      unless user_signed_in?
        redirect_to preview_video_path
      end

    end

    # Use callbacks to share common setup or constraints between actions.
    def set_video
      @video = Video.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_params
      params.require(:video).permit(:title, :description, :duration, :price,
                    :approved, :clip, :balance, :views, :user_id, :imdb_id, :public)
    end

    def test_users
      test_uids = ["108116283341322", "113454752806178", "118849962265351", "102626340558548", "112712999547131"]
      @test_users = User.where(uid: test_uids)
      @test_users.select { |user| user.account.plays.last == nil ||
                                  user.account.plays.last.created_at < 5.minutes.ago }
    end
end
