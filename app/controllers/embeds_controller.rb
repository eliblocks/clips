class EmbedsController < ApplicationController
  def show
    @video = Video.find(params[:id])

    if @video.removed || @video.suspended
      render 'unavailable'
    end

    if user_signed_in?
      if current_user.balance < @video.duration
        redirect_to buy_message_path
        session[:video_id] = @video.id
        session[:ref] = 'embed'
      end
    else
      redirect_to landing_path(video_id: @video.id)
    end
  end

  def landing
    @video = Video.find(params[:video_id])
  end

  def buy_message
    @video = Video.find(session[:video_id])
    unless current_user.balance < @video.duration
      redirect_to embed_path(@video.id)
    end
  end

  def thank_you
  end

end
