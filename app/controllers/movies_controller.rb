class MoviesController < ApplicationController
  before_action :set_movie, only: [:show, :edit, :update, :destroy, :remove, :restore]
  before_action :redirect_to_sign_up, only: [:new, :show, :edit, :update, :destroy]

  # GET /videos
  # GET /videos.json
  def index
    @movies = Video.featured
    .includes(:user)
    .order(created_at: :desc)
    .page(params[:page])
    .per(12)
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
    set_cloudfront_cookies
    if @movie.removed || @movie.suspended
      render 'embeds/unavailable'
    end
    if current_account.balance < 10
      flash[:notice] = "You're out of minutes! Buy more to keep watching"
      session[:video_id] = @video.id
      session[:ref] = 'site'
      redirect_to new_charge_path()
    end
  end

  # def search
  #   @videos = Video
  #   .search(params[:q], page: params[:page])
  #   render 'index'
  # end

  private

    def set_cloudfront_cookies
      signer = Aws::CloudFront::CookieSigner.new(
        key_pair_id: ENV["CLOUDFRONT_KEY_ID"],
        private_key: ENV["CLOUDFRONT_PRIVATE_KEY"]
      )


      url = "https://*.browzable.com/*"


      cloudfront_cookies = signer.signed_cookie(url, policy: cookie_policy.to_json)
      puts cloudfront_cookies

      cookies['CloudFront-Policy'] = {
        value: cloudfront_cookies['CloudFront-Policy'],
        domain: :all,
        expires: 1.days.from_now
      }
      cookies['CloudFront-Key-Pair-Id'] = {
        value: cloudfront_cookies['CloudFront-Key-Pair-Id'],
        domain: :all,
        expires: 1.days.from_now
      }
      cookies['CloudFront-Signature'] = {
        value: cloudfront_cookies['CloudFront-Signature'],
        domain: :all,
        expires: 1.days.from_now
      }
      cookies['Test-Cookie'] = {
        value: 'foo',
        domain: :all,
        expires: 1.years.from_now
      }
    end

    def cookie_policy
      {
        "Statement": [
          {
            "Resource":"https://*.browzable.com/*",
            "Condition":{
              "DateLessThan":{"AWS:EpochTime" => 1.days.from_now.to_i}
            }
          }
        ]
      }
    end

    def encoded_policy
      Base64.encode64(cookie_policy.to_json)
    end

    def redirect_to_sign_up
      unless user_signed_in?
        flash[:notice] = "Sign up or log in to watch"
        redirect_to new_user_session_path
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_movie
      @movie = Video.find(params[:id])
    end
end
